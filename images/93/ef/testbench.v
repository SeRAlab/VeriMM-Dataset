`timescale 1ns/1ps

module bin_to_7seg_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    wire [6:0] segments;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin_to_7seg dut (
        .bin(bin),
        .segments(segments)
    );
    task testcase001;

    begin
        test_num = 1;
        bin = 4'b0000;
        #9;
        #1;

        check_outputs(7'b0111111);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        bin = 4'b0001;
        #9;
        #1;

        check_outputs(7'b0000110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        bin = 4'b0010;
        #9;
        #1;

        check_outputs(7'b1011011);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        bin = 4'b0011;
        #9;
        #1;

        check_outputs(7'b1001111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        bin = 4'b0100;
        #9;
        #1;

        check_outputs(7'b1100110);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        bin = 4'b0101;
        #9;
        #1;

        check_outputs(7'b1101101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        bin = 4'b0110;
        #9;
        #1;

        check_outputs(7'b1111101);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        bin = 4'b0111;
        #9;
        #1;

        check_outputs(7'b0000111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        bin = 4'b1000;
        #9;
        #1;

        check_outputs(7'b1111111);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        bin = 4'b1001;
        #9;
        #1;

        check_outputs(7'b1101111);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        bin = 4'b1010;
        #9;
        #1;

        check_outputs(7'b1110111);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        bin = 4'b1011;
        #9;
        #1;

        check_outputs(7'b1111100);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        bin = 4'b1100;
        #9;
        #1;

        check_outputs(7'b0111001);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        bin = 4'b1101;
        #9;
        #1;

        check_outputs(7'b1011110);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        bin = 4'b1110;
        #9;
        #1;

        check_outputs(7'b1111001);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        bin = 4'b1111;
        #9;
        #1;

        check_outputs(7'b1110001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bin_to_7seg Testbench");
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
        input [6:0] expected_segments;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_segments === (expected_segments ^ segments ^ expected_segments)) begin
                $display("PASS");
                $display("  Outputs: segments=%h",
                         segments);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segments=%h",
                         expected_segments);
                $display("  Got:      segments=%h",
                         segments);
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
