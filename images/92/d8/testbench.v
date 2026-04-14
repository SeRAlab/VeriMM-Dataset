`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] IN0;
    reg [7:0] IN1;
    reg [7:0] IN2;
    reg [7:0] IN3;
    reg [1:0] SEL;
    wire [7:0] OUTA;
    wire [7:0] OUTB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IN0(IN0),
        .IN1(IN1),
        .IN2(IN2),
        .IN3(IN3),
        .SEL(SEL),
        .OUTA(OUTA),
        .OUTB(OUTB)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SEL=00 (Select IN0 for OUTA, IN2 for OUTB)", test_num);
        SEL = 2'b00;
        IN0 = 8'h11;
        IN1 = 8'h22;
        IN2 = 8'h33;
        IN3 = 8'h44;
        #1;

        check_outputs(8'h11, 8'h33);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SEL=01 (Select IN1 for OUTA, IN2 for OUTB)", test_num);
        SEL = 2'b01;
        IN0 = 8'h11;
        IN1 = 8'h22;
        IN2 = 8'h33;
        IN3 = 8'h44;
        #1;

        check_outputs(8'h22, 8'h33);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SEL=10 (Select IN0 for OUTA, IN3 for OUTB)", test_num);
        SEL = 2'b10;
        IN0 = 8'h11;
        IN1 = 8'h22;
        IN2 = 8'h33;
        IN3 = 8'h44;
        #1;

        check_outputs(8'h11, 8'h44);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SEL=11 (Select IN1 for OUTA, IN3 for OUTB)", test_num);
        SEL = 2'b11;
        IN0 = 8'h11;
        IN1 = 8'h22;
        IN2 = 8'h33;
        IN3 = 8'h44;
        #1;

        check_outputs(8'h22, 8'h44);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing All Zeros", test_num);
        SEL = 2'b00;
        IN0 = 8'h00;
        IN1 = 8'h00;
        IN2 = 8'h00;
        IN3 = 8'h00;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing All Ones", test_num);
        SEL = 2'b11;
        IN0 = 8'hFF;
        IN1 = 8'hFF;
        IN2 = 8'hFF;
        IN3 = 8'hFF;
        #1;

        check_outputs(8'hFF, 8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed Bit Patterns", test_num);
        SEL = 2'b01;
        IN0 = 8'hAA;
        IN1 = 8'h55;
        IN2 = 8'hF0;
        IN3 = 8'h0F;
        #1;

        check_outputs(8'h55, 8'hF0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_OUTA;
        input [7:0] expected_OUTB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUTA === (expected_OUTA ^ OUTA ^ expected_OUTA) &&
                expected_OUTB === (expected_OUTB ^ OUTB ^ expected_OUTB)) begin
                $display("PASS");
                $display("  Outputs: OUTA=%h, OUTB=%h",
                         OUTA, OUTB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUTA=%h, OUTB=%h",
                         expected_OUTA, expected_OUTB);
                $display("  Got:      OUTA=%h, OUTB=%h",
                         OUTA, OUTB);
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
