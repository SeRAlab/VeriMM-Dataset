`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] Addr;
    reg WR;
    reg clk;
    wire [7:0] LE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Addr(Addr),
        .WR(WR),
        .clk(clk),
        .LE(LE)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset behavior (WR=0)", test_num);

        WR = 0;
        Addr = 3'b000;
        @(posedge clk);

        #1;


        check_outputs(8'b00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write Addr 0 (LE[0])", test_num);

        WR = 0; @(posedge clk);

        WR = 1;
        Addr = 3'b000;
        @(posedge clk);
        #1;

        check_outputs(8'b00000001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write Addr 1 (LE[1])", test_num);

        WR = 0; @(posedge clk);

        WR = 1;
        Addr = 3'b001;
        @(posedge clk);
        #1;

        check_outputs(8'b00000010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write Addr 3 (LE[3])", test_num);

        WR = 0; @(posedge clk);

        WR = 1;
        Addr = 3'b011;
        @(posedge clk);
        #1;

        check_outputs(8'b00001000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write Addr 7 (LE[7])", test_num);

        WR = 0; @(posedge clk);

        WR = 1;
        Addr = 3'b111;
        @(posedge clk);
        #1;

        check_outputs(8'b10000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify zeroing when WR drops", test_num);

        WR = 1; Addr = 3'b101; @(posedge clk);

        WR = 0;
        @(posedge clk);
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Address change while WR=0", test_num);

        WR = 0; Addr = 3'b000; @(posedge clk);

        Addr = 3'b010;
        @(posedge clk);
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Consecutive writes (Addr 2 then Addr 4)", test_num);

        WR = 0; @(posedge clk);

        WR = 1; Addr = 3'b010; @(posedge clk);

        Addr = 3'b100; @(posedge clk);
        #1;

        check_outputs(8'b00010000);
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
        testcase008();
        
        
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
        input [7:0] expected_LE;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LE === (expected_LE ^ LE ^ expected_LE)) begin
                $display("PASS");
                $display("  Outputs: LE=%h",
                         LE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LE=%h",
                         expected_LE);
                $display("  Got:      LE=%h",
                         LE);
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
