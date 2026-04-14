`timescale 1ns/1ps

module mux16to1_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    reg [3:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux16to1 dut (
        .in(in),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        in = 16'h0001;
        sel = 4'd0;
        $display("Testcase %0d: Selecting Channel 0 (Expect 1)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in = 16'hFFFE;
        sel = 4'd0;
        $display("Testcase %0d: Selecting Channel 0 (Expect 0)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in = 16'h0002;
        sel = 4'd1;
        $display("Testcase %0d: Selecting Channel 1 (Expect 1)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in = 16'h0008;
        sel = 4'd3;
        $display("Testcase %0d: Selecting Channel 3 (Expect 1)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in = 16'h0080;
        sel = 4'd7;
        $display("Testcase %0d: Selecting Channel 7 (Expect 1)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in = 16'h0100;
        sel = 4'd8;
        $display("Testcase %0d: Selecting Channel 8 (Expect 1)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in = 16'h8000;
        sel = 4'd15;
        $display("Testcase %0d: Selecting Channel 15 (Expect 1)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 16'h7FFF;
        sel = 4'd15;
        $display("Testcase %0d: Selecting Channel 15 (Expect 0)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in = 16'hAAAA;
        sel = 4'd1;
        $display("Testcase %0d: Pattern 0xAAAA, Select 1 (Expect 1)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in = 16'hAAAA;
        sel = 4'd0;
        $display("Testcase %0d: Pattern 0xAAAA, Select 0 (Expect 0)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        in = 16'h5555;
        sel = 4'd0;
        $display("Testcase %0d: Pattern 0x5555, Select 0 (Expect 1)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        in = 16'h1234;
        sel = 4'd4;
        $display("Testcase %0d: Pattern 0x1234, Select 4 (Expect 1)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        in = 16'h1234;
        sel = 4'd3;
        $display("Testcase %0d: Pattern 0x1234, Select 3 (Expect 0)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        in = 16'hFFFF;
        sel = 4'd12;
        $display("Testcase %0d: All 1s, Select 12 (Expect 1)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        in = 16'h0000;
        sel = 4'd6;
        $display("Testcase %0d: All 0s, Select 6 (Expect 0)", test_num);
        #1;

        check_outputs(1'b0);
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
