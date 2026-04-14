`timescale 1ns/1ps

module decoder_4to16_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [3:0] in;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_4to16 dut (
        .enable(enable),
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Enable=0, in=4'h5", test_num);
        enable = 0;
        in = 4'h5;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Enable=0, in=4'hF", test_num);
        enable = 0;
        in = 4'hF;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Enable=1, in=4'h0", test_num);
        enable = 1;
        in = 4'h0;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Enable=1, in=4'h4", test_num);
        enable = 1;
        in = 4'h4;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Enable=1, in=4'h8", test_num);
        enable = 1;
        in = 4'h8;
        #1;

        check_outputs(16'h0100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Enable=1, in=4'hF", test_num);
        enable = 1;
        in = 4'hF;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase007;

        integer i;
        reg [15:0] expected;
    begin
        test_num = 7;
        $display("Testcase %0d: Exhaustive Enabled Loop", test_num);
        enable = 1;
        for (i = 0; i < 16; i = i + 1) begin
            in = i;
            expected = 16'b1 << i;
            #1;
            if (out !== expected) begin
                $display("  Loop failed at input %0d", i);

            end
        end


        #1;



        check_outputs(16'h8000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_4to16 Testbench");
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
        input [15:0] expected_out;
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
