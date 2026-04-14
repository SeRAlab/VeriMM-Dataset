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
    task testcase000;

        begin
            test_num = 0;
            $display("Test Case %0d: Input = 4'h0", test_num);
            bin = 4'h0;
            #1;

            check_outputs(7'b1111110);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Input = 4'h1", test_num);
            bin = 4'h1;
            #1;

            check_outputs(7'b0110000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Input = 4'h2", test_num);
            bin = 4'h2;
            #1;

            check_outputs(7'b1101101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Input = 4'h3", test_num);
            bin = 4'h3;
            #1;

            check_outputs(7'b1111001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Input = 4'h4", test_num);
            bin = 4'h4;
            #1;

            check_outputs(7'b0110011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Input = 4'h5", test_num);
            bin = 4'h5;
            #1;

            check_outputs(7'b1011011);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Input = 4'h6", test_num);
            bin = 4'h6;
            #1;

            check_outputs(7'b1011111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Input = 4'h7", test_num);
            bin = 4'h7;
            #1;

            check_outputs(7'b1110000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Input = 4'h8", test_num);
            bin = 4'h8;
            #1;

            check_outputs(7'b1111111);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Input = 4'h9", test_num);
            bin = 4'h9;
            #1;

            check_outputs(7'b1111011);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Input = 4'hA", test_num);
            bin = 4'hA;
            #1;

            check_outputs(7'b1110111);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test Case %0d: Input = 4'hB", test_num);
            bin = 4'hB;
            #1;

            check_outputs(7'b0011111);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test Case %0d: Input = 4'hC", test_num);
            bin = 4'hC;
            #1;

            check_outputs(7'b1001110);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Test Case %0d: Input = 4'hD", test_num);
            bin = 4'hD;
            #1;

            check_outputs(7'b0111101);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            $display("Test Case %0d: Input = 4'hE", test_num);
            bin = 4'hE;
            #1;

            check_outputs(7'b1001111);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            $display("Test Case %0d: Input = 4'hF", test_num);
            bin = 4'hF;
            #1;

            check_outputs(7'b1000111);
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


        testcase000();
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
