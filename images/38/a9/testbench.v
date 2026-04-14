`timescale 1ns/1ps

module encoder_8to3_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder_8to3 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: No inputs asserted", test_num);
        in = 8'b0000_0000;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Only in0 asserted", test_num);
        in = 8'b0000_0001;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Only in7 asserted", test_num);
        in = 8'b1000_0000;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Only in4 asserted", test_num);
        in = 8'b0001_0000;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Priority check - in7 and in0 high (in7 wins)", test_num);
        in = 8'b1000_0001;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Priority check - in4, in3, in2, in1, in0 high (in4 wins)", test_num);
        in = 8'b0001_1111;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs asserted (in7 wins)", test_num);
        in = 8'b1111_1111;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Only in1 asserted", test_num);
        in = 8'b0000_0010;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Only in6 asserted", test_num);
        in = 8'b0100_0000;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Priority check - in3 and in1 high (in3 wins)", test_num);
        in = 8'b0000_1010;
        #1;

        check_outputs(3'b011);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("encoder_8to3 Testbench");
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
        input [2:0] expected_out;
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
