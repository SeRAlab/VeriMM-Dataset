`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    reg [2:0] shift;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .data(data),
        .shift(shift),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            data = 4'b1011; shift = 3'd0;
            $display("Test %0d: Data=%b, Shift=%0d (No Shift)", test_num, data, shift);
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            data = 4'b1011; shift = 3'd1;
            $display("Test %0d: Data=%b, Shift=%0d (Shift Left 1)", test_num, data, shift);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            data = 4'b1011; shift = 3'd2;
            $display("Test %0d: Data=%b, Shift=%0d (Shift Left 2)", test_num, data, shift);
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            data = 4'b1011; shift = 3'd3;
            $display("Test %0d: Data=%b, Shift=%0d (Shift Left 3)", test_num, data, shift);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            data = 4'b1011; shift = 3'd4;
            $display("Test %0d: Data=%b, Shift=%0d (Rotate Left 0)", test_num, data, shift);
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            data = 4'b1011; shift = 3'd5;
            $display("Test %0d: Data=%b, Shift=%0d (Rotate Left 1)", test_num, data, shift);
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            data = 4'b1011; shift = 3'd6;
            $display("Test %0d: Data=%b, Shift=%0d (Rotate Left 2)", test_num, data, shift);
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            data = 4'b1011; shift = 3'd7;
            $display("Test %0d: Data=%b, Shift=%0d (Rotate Left 3)", test_num, data, shift);
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            data = 4'b0001; shift = 3'd2;
            $display("Test %0d: Data=%b, Shift=%0d (Single Bit Shift)", test_num, data, shift);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            data = 4'b1000; shift = 3'd5;
            $display("Test %0d: Data=%b, Shift=%0d (Rotate MSB to LSB)", test_num, data, shift);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("barrel_shifter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
