`timescale 1ns/1ps

module decoder4to16_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg [3:0] in;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder4to16 dut (
        .en(en),
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            en = 1'b0;
            in = 4'h0;
            $display("Testcase %03d: Disabled Check (en=0, in=0)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            en = 1'b0;
            in = 4'hF;
            $display("Testcase %03d: Disabled Check (en=0, in=F)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            en = 1'b1;
            in = 4'h0;
            $display("Testcase %03d: Enabled Check (en=1, in=0)", test_num);
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            en = 1'b1;
            in = 4'h1;
            $display("Testcase %03d: Enabled Check (en=1, in=1)", test_num);
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            en = 1'b1;
            in = 4'h3;
            $display("Testcase %03d: Enabled Check (en=1, in=3)", test_num);
            #1;

            check_outputs(16'h0008);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            en = 1'b1;
            in = 4'h4;
            $display("Testcase %03d: Enabled Check (en=1, in=4)", test_num);
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            en = 1'b1;
            in = 4'h7;
            $display("Testcase %03d: Enabled Check (en=1, in=7)", test_num);
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            en = 1'b1;
            in = 4'h8;
            $display("Testcase %03d: Enabled Check (en=1, in=8)", test_num);
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            en = 1'b1;
            in = 4'hB;
            $display("Testcase %03d: Enabled Check (en=1, in=B)", test_num);
            #1;

            check_outputs(16'h0800);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            en = 1'b1;
            in = 4'hE;
            $display("Testcase %03d: Enabled Check (en=1, in=E)", test_num);
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            en = 1'b1;
            in = 4'hF;
            $display("Testcase %03d: Enabled Check (en=1, in=F)", test_num);
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
        $display("decoder4to16 Testbench");
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
        testcase011();
        
        
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
