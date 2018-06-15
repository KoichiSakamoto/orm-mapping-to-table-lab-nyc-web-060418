require 'pry'
class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id


  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql_string = <<-SQL
      CREATE TABLE students (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      grade INTEGER)
    SQL
    DB[:conn].execute(sql_string)
  end

  def self.drop_table
    sql_string = <<-SQL
      DROP TABLE students
    SQL
    DB[:conn].execute(sql_string)
  end

  def save
    sql_string = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?,?)
    SQL
    DB[:conn].execute(sql_string, [@name, @grade])
    sql_string = <<-SQL
      SELECT last_insert_rowid()
    SQL
    @id = DB[:conn].execute(sql_string)[0][0]
    self
  end

  def self.create(hash)
    new_kid = Student.new(hash[:name], hash[:grade])
    new_kid.save
    new_kid
  end

end
