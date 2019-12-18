require_relative "../config/environment.rb"

class Student

  attr_accessor :id, :name, :grade
  
  def initialize(id=nil,name,grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.new_from_db(row)
    new_student = self.new  # self.new is the same as running Song.new
    new_student.id = row[0]
    new_student.name =  row[1]
    new_student.grade = row[2]
    new_student
    end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL
 
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL
 
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def self.all_students_in_grade_9
    sql = <<-SQL
     SELECT *
     FROM students
     WHERE grade = 9
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.first_student_in_grade_10
    sql = <<-SQL
     SELECT *
     FROM students
     WHERE grade = 10
     LIMIT 1
    SQL
    
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end.first
  end
  
   def self.students_below_12th_grade
    sql = <<-SQL
     SELECT *
     FROM students
     WHERE grade < 12
    SQL
    
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end
  
  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
     SELECT *
     FROM students
     WHERE grade = 10
     LIMIT ?
    SQL
    
    DB[:conn].execute(sql,x).collect do |row|
      self.new_from_db(row)
    end
  end
  
  def self.all_students_in_grade_X(x)
    sql = <<-SQL
     SELECT *
     FROM students
     WHERE grade = ?
    SQL
    
    DB[:conn].execute(sql,x).collect do |row|
      self.new_from_db(row)
    end
  end
  
  def save
    if self.id
      self.update
    else
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end
  
  def update
    sql = "UPDATE students SET name = ?, album = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

end
