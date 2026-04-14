`timescale 1ns/1ps

module VirtualMemoryManagement_tb;

    // Testbench signals (combinational circuit)
    reg valid;
    reg [7:0] virtual_address;
    wire error;
    wire [7:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VirtualMemoryManagement dut (
        .valid(valid),
        .virtual_address(virtual_address),
        .error(error),
        .physical_address(physical_address)
    );
    task testcase001;

        begin
            test_num = 1;
            valid = 1'b0;
            virtual_address = 8'h05;

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            valid = 1'b1;
            virtual_address = 8'h05;

            #1;


            check_outputs(1'b0, 8'h15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            valid = 1'b1;
            virtual_address = 8'h1A;

            #1;


            check_outputs(1'b0, 8'h2A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            valid = 1'b1;
            virtual_address = 8'h80;

            #1;


            check_outputs(1'b0, 8'h90);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            valid = 1'b1;
            virtual_address = 8'hFF;

            #1;


            check_outputs(1'b0, 8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            valid = 1'b0;
            virtual_address = 8'hFF;

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            valid = 1'b1;
            virtual_address = 8'h22;

            #1;


            check_outputs(1'b0, 8'h32);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VirtualMemoryManagement Testbench");
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
        input expected_error;
        input [7:0] expected_physical_address;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address)) begin
                $display("PASS");
                $display("  Outputs: error=%b, physical_address=%h",
                         error, physical_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, physical_address=%h",
                         expected_error, expected_physical_address);
                $display("  Got:      error=%b, physical_address=%h",
                         error, physical_address);
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
