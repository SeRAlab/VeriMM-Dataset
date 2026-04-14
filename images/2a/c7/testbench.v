`timescale 1ns/1ps

module mux16to1_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] I;
    reg [3:0] S;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux16to1 dut (
        .I(I),
        .S(S),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Select line 0 - bit is 1", test_num);
        I = 16'h0001; S = 4'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Select line 1 - bit is 1", test_num);
        I = 16'h0002; S = 4'd1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Select line 2 - bit is 1", test_num);
        I = 16'h0004; S = 4'd2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Select line 3 - bit is 1", test_num);
        I = 16'h0008; S = 4'd3;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Select line 4 - bit is 1", test_num);
        I = 16'h0010; S = 4'd4;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Select line 5 - bit is 1", test_num);
        I = 16'h0020; S = 4'd5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Select line 6 - bit is 1", test_num);
        I = 16'h0040; S = 4'd6;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Select line 7 - bit is 1", test_num);
        I = 16'h0080; S = 4'd7;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Select line 8 - bit is 1", test_num);
        I = 16'h0100; S = 4'd8;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Select line 9 - bit is 1", test_num);
        I = 16'h0200; S = 4'd9;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: Select line 10 - bit is 1", test_num);
        I = 16'h0400; S = 4'd10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: Select line 11 - bit is 1", test_num);
        I = 16'h0800; S = 4'd11;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test %0d: Select line 12 - bit is 1", test_num);
        I = 16'h1000; S = 4'd12;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Test %0d: Select line 13 - bit is 1", test_num);
        I = 16'h2000; S = 4'd13;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Test %0d: Select line 14 - bit is 1", test_num);
        I = 16'h4000; S = 4'd14;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Test %0d: Select line 15 - bit is 1", test_num);
        I = 16'h8000; S = 4'd15;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase017;

    begin
        test_num = 17;
        $display("Test %0d: All inputs 0", test_num);
        I = 16'h0000; S = 4'd7;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase018;

    begin
        test_num = 18;
        $display("Test %0d: All inputs 1", test_num);
        I = 16'hFFFF; S = 4'd12;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase019;

    begin
        test_num = 19;
        $display("Test %0d: Mixed inputs (AAAA), select 0-bit", test_num);
        I = 16'hAAAA; S = 4'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase020;

    begin
        test_num = 20;
        $display("Test %0d: Mixed inputs (AAAA), select 1-bit", test_num);
        I = 16'hAAAA; S = 4'd1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux16to1 Testbench");
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
        testcase017();
        testcase018();
        testcase019();
        testcase020();
        
        
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
