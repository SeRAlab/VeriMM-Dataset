`timescale 1ns/1ps

module flash_memory_cell_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg write_enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory_cell dut (
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial Write", test_num);

            write_enable = 1;
            data_in = 8'hA5;
            #10;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hold value when write_enable is low", test_num);

            write_enable = 1;
            data_in = 8'hA5;
            #10;

            write_enable = 0;
            data_in = 8'hFF;
            #10;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overwrite existing value", test_num);

            write_enable = 0;
            #5;

            write_enable = 1;
            data_in = 8'h5A;
            #10;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data stability with multiple input changes (WE=0)", test_num);

            write_enable = 1;
            data_in = 8'h33;
            #10;

            write_enable = 0;
            data_in = 8'h00; #5;
            data_in = 8'hFF; #5;
            data_in = 8'hAA; #5;

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Writing Zero value", test_num);

            write_enable = 1;
            data_in = 8'h00;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Writing All-Ones value", test_num);

            write_enable = 1;
            data_in = 8'hFF;
            #10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory_cell Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
