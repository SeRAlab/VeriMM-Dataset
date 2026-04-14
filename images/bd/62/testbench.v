`timescale 1ns/1ps

module seven_segment_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    seven_segment_decoder dut (
        .bin(bin),
        .seg(seg)
    );
    task testcase001;

        begin
            bin = 4'h0;
            #1;

            check_outputs(7'h3f);
        end
        endtask

    task testcase002;

        begin
            bin = 4'h1;
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            bin = 4'h2;
            #1;

            check_outputs(7'h5b);
        end
        endtask

    task testcase004;

        begin
            bin = 4'h3;
            #1;

            check_outputs(7'h4f);
        end
        endtask

    task testcase005;

        begin
            bin = 4'h4;
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            bin = 4'h5;
            #1;

            check_outputs(7'h6d);
        end
        endtask

    task testcase007;

        begin
            bin = 4'h6;
            #1;

            check_outputs(7'h7d);
        end
        endtask

    task testcase008;

        begin
            bin = 4'h7;
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            bin = 4'h8;
            #1;

            check_outputs(7'h7f);
        end
        endtask

    task testcase010;

        begin
            bin = 4'h9;
            #1;

            check_outputs(7'h6f);
        end
        endtask

    task testcase011;

        begin
            bin = 4'ha;
            #1;

            check_outputs(7'h77);
        end
        endtask

    task testcase012;

        begin
            bin = 4'hb;
            #1;

            check_outputs(7'h7c);
        end
        endtask

    task testcase013;

        begin
            bin = 4'hc;
            #1;

            check_outputs(7'h39);
        end
        endtask

    task testcase014;

        begin
            bin = 4'hd;
            #1;

            check_outputs(7'h5e);
        end
        endtask

    task testcase015;

        begin
            bin = 4'he;
            #1;

            check_outputs(7'h79);
        end
        endtask

    task testcase016;

        begin
            bin = 4'hf;
            #1;

            check_outputs(7'h71);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("seven_segment_decoder Testbench");
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
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [6:0] expected_seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: seg=%h",
                         seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg=%h",
                         expected_seg);
                $display("  Got:      seg=%h",
                         seg);
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
