const should = require('should');
const parser = require('./dist/parser').parser;

describe('advanced-search-query', function() {
  it('only word', function() {
    parser.parse('寿司')
      .should.have.property('q')
      .with.deepEqual(['寿司']);
  });
  it('only text query', function() {
    parser.parse('soba udon')
      .should.have.property('q')
      .with.deepEqual(['soba', 'udon']);
  });
  
  it('query only(explicit)', function() {
    parser.parse('q:sushi,tenpula')
      .should.have.property('q')
      .with.deepEqual(['sushi', 'tenpula']);
  });
  it('tag and query(explicit)', function() {
    let res = parser.parse('tag:food q:oyako-don,ten-don')
    res.should.have.property('q')
      .with.deepEqual(['oyako-don', 'ten-don'])
    res.should.have.property('tag')
      .with.deepEqual(['food'])
  });
  it('tag and query(implicit)', function() {
    let res = parser.parse('tag:restaurant まとめ 東京')
    res.should.have.property('q')
      .with.deepEqual(['まとめ', '東京']);
    res.should.have.property('tag')
      .with.deepEqual(['restaurant'])
  });
  
});

