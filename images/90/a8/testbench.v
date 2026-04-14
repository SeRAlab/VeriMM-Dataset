`timescale 1ns/1ps

module decoder_4to16_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_4to16 dut (
        .a(a),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Input a = 0", test_num);
        a = 4'd0;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Input a = 1", test_num);
        a = 4'd1;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Input a = 2", test_num);
        a = 4'd2;
        #1;

        check_outputs(16'h0004);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Input a = 3", test_num);
        a = 4'd3;
        #1;

        check_outputs(16'h0008);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Input a = 4", test_num);
        a = 4'd4;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Input a = 5", test_num);
        a = 4'd5;
        #1;

        check_outputs(16'h0020);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Input a = 6", test_num);
        a = 4'd6;
        #1;

        check_outputs(16'h0040);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Input a = 7", test_num);
        a = 4'd7;
        #1;

        check_outputs(16'h0080);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Input a = 8", test_num);
        a = 4'd8;
        #1;

        check_outputs(16'h0100);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Input a = 9", test_num);
        a = 4'd9;
        #1;

        check_outputs(16'h0200);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Input a = 10", test_num);
        a = 4'd10;
        #1;

        check_outputs(16'h0400);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: Input a = 11", test_num);
        a = 4'd11;
        #1;

        check_outputs(16'h0800);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Testcase %0d: Input a = 12", test_num);
        a = 4'd12;
        #1;

        check_outputs(16'h1000);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Testcase %0d: Input a = 13", test_num);
        a = 4'd13;
        #1;

        check_outputs(16'h2000);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Testcase %0d: Input a = 14", test_num);
        a = 4'd14;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Testcase %0d: Input a = 15", test_num);
        a = 4'd15;
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
        input [15:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
