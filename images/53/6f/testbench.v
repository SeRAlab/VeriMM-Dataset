`timescale 1ns/1ps

module d_latch_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] d;
    reg en;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    d_latch dut (
        .d(d),
        .en(en),
        .q(q)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Transparent mode (q should follow d)", test_num);

            en = 1;
            d = 3'b000;
            #10;

            d = 3'b101;
            #10;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Latch mode (en=0 should hold value)", test_num);

            en = 1;
            d = 3'b010;
            #10;

            en = 0;
            #5;

            d = 3'b111;
            #10;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Transparency with all bits high", test_num);

            en = 1;
            d = 3'b111;
            #10;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Multiple data changes while latched", test_num);

            en = 1;
            d = 3'b100;
            #10;

            en = 0;
            #5;
            d = 3'b001; #5;
            d = 3'b111; #5;
            d = 3'b000; #10;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Re-enabling transparency", test_num);

            en = 0;
            d = 3'b111;
            #10;

            en = 1;
            #5;
            d = 3'b011;
            #10;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Transitioning all bits low in transparent mode", test_num);
            en = 1;
            d = 3'b111;
            #10;
            d = 3'b000;
            #10;
            #1;

            check_outputs(3'b000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("d_latch Testbench");
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
        input [2:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
