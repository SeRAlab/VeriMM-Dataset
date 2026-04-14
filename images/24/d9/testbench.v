`timescale 1ns/1ps

module DAC_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] din;
    wire [9:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_8bit dut (
        .din(din),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = 1;
            din = 8'd0;

            $display("Test Case %0d: Input = %d (Zero)", test_num, din);
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            din = 8'd1;

            $display("Test Case %0d: Input = %d (Step 1)", test_num, din);
            #1;

            check_outputs(10'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            din = 8'd64;

            $display("Test Case %0d: Input = %d (Quarter Scale)", test_num, din);
            #1;

            check_outputs(10'd256);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            din = 8'd127;

            $display("Test Case %0d: Input = %d", test_num, din);
            #1;

            check_outputs(10'd508);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            din = 8'd128;

            $display("Test Case %0d: Input = %d (Midpoint)", test_num, din);
            #1;

            check_outputs(10'd512);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            din = 8'b10101010;

            $display("Test Case %0d: Input = 8'b10101010", test_num);
            #1;

            check_outputs(10'd680);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            din = 8'b01010101;

            $display("Test Case %0d: Input = 8'b01010101", test_num);
            #1;

            check_outputs(10'd340);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            din = 8'd255;

            $display("Test Case %0d: Input = %d (Full Scale)", test_num, din);
            #1;

            check_outputs(10'd1020);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_8bit Testbench");
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
        input [9:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
