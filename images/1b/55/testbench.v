`timescale 1ns/1ps

module simple_hash_table_tb;

    // Testbench signals (combinational circuit)
    reg insert;
    reg [4:0] key;
    reg retrieve;
    reg [7:0] value;
    wire found;
    wire [7:0] out_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_hash_table dut (
        .insert(insert),
        .key(key),
        .retrieve(retrieve),
        .value(value),
        .found(found),
        .out_value(out_value)
    );
    task reset_inputs;

        begin
            insert = 0;
            retrieve = 0;
            key = 0;
            value = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Insert and Retrieve", test_num);
            reset_inputs();


            insert = 1;
            key = 5'h05;
            value = 8'hAB;
            #10;
            insert = 0;
            #5;


            retrieve = 1;
            key = 5'h05;
            #10;

            #1;


            check_outputs(1'b1, 8'hAB);
            retrieve = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Retrieve Non-existent Key", test_num);
            reset_inputs();


            retrieve = 1;
            key = 5'h1F;
            #10;


            #1;



            check_outputs(1'b0, 8'h00);
            retrieve = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Existing Key", test_num);
            reset_inputs();


            insert = 1;
            key = 5'h0A;
            value = 8'h11;
            #10;


            value = 8'h22;
            #10;
            insert = 0;
            #5;


            retrieve = 1;
            key = 5'h0A;
            #10;

            #1;


            check_outputs(1'b1, 8'h22);
            retrieve = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Keys Boundary Test", test_num);
            reset_inputs();


            insert = 1;
            key = 5'd0;
            value = 8'hDE;
            #10;


            key = 5'd31;
            value = 8'hAD;
            #10;
            insert = 0;


            retrieve = 1;
            key = 5'd0;
            #10;


            #1;



            check_outputs(1'b1, 8'hDE);


            key = 5'd31;
            #10;


            #1;



            check_outputs(1'b1, 8'hAD);
            retrieve = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Control (Priority Test)", test_num);
            reset_inputs();


            insert = 1;
            key = 5'h12;
            value = 8'hCF;
            #10;
            insert = 0;
            #5;



            insert = 1;
            retrieve = 1;
            key = 5'h12;
            value = 8'hFF;
            #10;




            #1;





            check_outputs(1'b1, 8'hFF);

            insert = 0;
            retrieve = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_hash_table Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_found;
        input [7:0] expected_out_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_found === (expected_found ^ found ^ expected_found) &&
                expected_out_value === (expected_out_value ^ out_value ^ expected_out_value)) begin
                $display("PASS");
                $display("  Outputs: found=%b, out_value=%h",
                         found, out_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: found=%b, out_value=%h",
                         expected_found, expected_out_value);
                $display("  Got:      found=%b, out_value=%h",
                         found, out_value);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
