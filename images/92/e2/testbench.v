`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    reg last_in;
    reg ready_out;
    reg reset_in;
    reg [7:0] set_addr_in;
    reg set_stb_in;
    reg valid_in;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .last_in(last_in),
        .ready_out(ready_out),
        .reset_in(reset_in),
        .set_addr_in(set_addr_in),
        .set_stb_in(set_stb_in),
        .valid_in(valid_in)
    );
    task testcase001;

        begin
            test_num = 1;
            reset_in = 1;
            data_in = 0; last_in = 0; ready_out = 0;
            set_addr_in = 0; set_stb_in = 0; valid_in = 0;
            #20;
            reset_in = 0;
            #10;
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_in = 1; #10; reset_in = 0; #10;
            set_addr_in = 8'hA5;
            set_stb_in = 1;
            #10;
            set_stb_in = 0;
            #10;
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_in = 1; #10; reset_in = 0; #10;
            ready_out = 1;
            data_in = 32'hDEADBEEF;
            valid_in = 1;
            #10;
            valid_in = 0;
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_in = 1; #10; reset_in = 0; #10;
            ready_out = 1;
            valid_in = 1;
            data_in = 32'h11111111; #10;
            data_in = 32'h22222222; #10;
            data_in = 32'h33333333; #10;
            valid_in = 0;
            #1;

            check_outputs();
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_in = 1; #10; reset_in = 0; #10;
            ready_out = 1;
            valid_in = 1;
            data_in = 32'hFFFFFFFF;
            last_in = 1;
            #10;
            valid_in = 0;
            last_in = 0;
            #1;

            check_outputs();
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_in = 1; #10; reset_in = 0; #10;
            ready_out = 0;
            data_in = 32'hABCDE123;
            valid_in = 1;
            #20;
            ready_out = 1;
            #10;
            valid_in = 0;
            #1;

            check_outputs();
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_in = 1; #10; reset_in = 0; #10;
            set_addr_in = 8'h01;
            set_stb_in = 1;
            data_in = 32'hCAFEBABE;
            valid_in = 1;
            ready_out = 1;
            #10;
            set_stb_in = 0;
            valid_in = 0;
            #1;

            check_outputs();
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
