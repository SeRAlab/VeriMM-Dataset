`timescale 1ns/1ps

module decoder_3to8_tb;

    // Testbench signals (combinational circuit)
    reg EN;
    reg [2:0] IN;
    wire [7:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_3to8 dut (
        .EN(EN),
        .IN(IN),
        .OUT(OUT)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Disable signal check (EN=0, IN=000)", test_num);
        EN = 1'b0;
        IN = 3'b000;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Disable signal check (EN=0, IN=111)", test_num);
        EN = 1'b0;
        IN = 3'b111;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Enable check IN=0 (000)", test_num);
        EN = 1'b1;
        IN = 3'b000;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Enable check IN=1 (001)", test_num);
        EN = 1'b1;
        IN = 3'b001;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Enable check IN=2 (010)", test_num);
        EN = 1'b1;
        IN = 3'b010;
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Enable check IN=3 (011)", test_num);
        EN = 1'b1;
        IN = 3'b011;
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Enable check IN=4 (100)", test_num);
        EN = 1'b1;
        IN = 3'b100;
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Enable check IN=5 (101)", test_num);
        EN = 1'b1;
        IN = 3'b101;
        #1;

        check_outputs(8'h20);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Enable check IN=6 (110)", test_num);
        EN = 1'b1;
        IN = 3'b110;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Enable check IN=7 (111)", test_num);
        EN = 1'b1;
        IN = 3'b111;
        #1;

        check_outputs(8'h80);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_3to8 Testbench");
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
        input [7:0] expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
