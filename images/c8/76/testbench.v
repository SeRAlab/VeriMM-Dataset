`timescale 1ns/1ps

module little_endian_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    wire [1:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    little_endian dut (
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 4'b0000;
            #1;
            $display("Test %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 4'b1000;
            #1;
            $display("Test %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 4'b0100;
            #1;
            $display("Test %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 4'b1100;
            #1;
            $display("Test %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 4'b1011;
            #1;
            $display("Test %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 4'b0111;
            #1;
            $display("Test %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 4'b1111;
            #1;
            $display("Test %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data_in = 4'b0011;
            #1;
            $display("Test %0d: data_in = %b", test_num, data_in);
            #1;

            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("little_endian Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [1:0] expected_data_out;
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
