# --------------------------------------------------------------------------- #
                             # SEARCH #

                             def prep_query(info_hash)
                                # INPUTS FROM SEARCH FORM
                                first_name = info_hash[:first_name] # FIRST NAME
                                phone = info_hash[:phone]           # PHONE NUMBER
                            
                              # If they enter a first name and lastname- SEARCH WITH BOTH
                                if first_name != '' && phone != ''
                                    print "SELECT * FROM data WHERE first_name='#{first_name}' AND phonenumber='#{phone}'"
                                    "SELECT * FROM data WHERE first_name='#{first_name}' AND phonenumber='#{phone}'"
                                # OR ELSE IF IT WAS JUST THE FIRST NAME- SEARCH WITH JUST THE FIRST NAME
                                elsif first_name != ''
                                    print "SELECT * FROM data WHERE first_name='#{first_name}'"
                                    "SELECT * FROM data WHERE first_name='#{first_name}'"
                              # OR ELSE IF it WAS JUST THE SEARCH WITH JUST THE PHONE NUMBER, SEARCH WITH JUST THE PHONE NUMBER
                                elsif phone != ''
                                    print "SELECT * FROM data WHERE phonenumber='#{phone}'"
                                    "SELECT * FROM data WHERE phonenumber='#{phone}'"
                                # IF NOT BOTH NOR EITHER ONE PROMT THE USER OF THIS
                                else
                                    print "SELECT * FROM data"
                                    "SELECT * FROM data"
                                end
                            end
                        
                            
                            # RUNS SQL QUERY AND RETURNS DATA OBJECT
                            def response_obj(query)
                                $db.exec(query)
                            end
                            
                            # PREPARE HTML TABLE
                            def prep_html(response_obj)
                                html = ''
                                html << "<table>
                                <tr>
                                    <td>First Name</td>
                                    <td>Last Name</td>
                                    <td>Street Address</td>
                                    <td>City</td>
                                    <td>State</td>
                                    <td>Zipcode</td>
                                    <td>Phone Number</td>
                                  </tr>"
                            
                                # GENERATE ROW
                              response_obj.each do |row|
                                    html << "\t<tr>"
                                    row.each {|cell| html << "\t\t<td>#{cell[1]}</td>\n"}
                                    html << "\t</tr>"
                                end
                                # END TABLE
                                html << "</table>"
                                # RETURN FINAL STRING
                                html
                            end
                            
                            # TIE THEM ALL TOGETHER
                            def full_search_table_render(form_input_hash)
                                prep_html(response_obj(prep_query(form_input_hash)))
                            end                             