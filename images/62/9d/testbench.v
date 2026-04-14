`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] ina;
    reg [127:0] inb;
    reg sel;
    wire [127:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ina(ina),
        .inb(inb),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select inb (sel=0) with hex patterns", test_num);
        ina = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        inb = 128'h55555555555555555555555555555555;
        sel = 1'b0;
        #1;

        check_outputs(128'h55555555555555555555555555555555);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select ina (sel=1) with hex patterns", test_num);
        ina = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        inb = 128'h55555555555555555555555555555555;
        sel = 1'b1;
        #1;

        check_outputs(128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select inb (sel=0) with all zeros vs all ones", test_num);
        ina = 128'h00000000000000000000000000000000;
        inb = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        sel = 1'b0;
        #1;

        check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select ina (sel=1) with all zeros vs all ones", test_num);
        ina = 128'h00000000000000000000000000000000;
        inb = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        sel = 1'b1;
        #1;

        check_outputs(128'h00000000000000000000000000000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select inb (sel=0) with unique 64-bit halves", test_num);
        ina = 128'hDEADC0DEBEEFBABE0123456789ABCDEF;
        inb = 128'hFEDCBA9876543210CAFEBABEBAADF00D;
        sel = 1'b0;
        #1;

        check_outputs(128'hFEDCBA9876543210CAFEBABEBAADF00D);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select ina (sel=1) with unique 64-bit halves", test_num);
        ina = 128'hDEADC0DEBEEFBABE0123456789ABCDEF;
        inb = 128'hFEDCBA9876543210CAFEBABEBAADF00D;
        sel = 1'b1;
        #1;

        check_outputs(128'hDEADC0DEBEEFBABE0123456789ABCDEF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Checking single bit transitions on sel", test_num);
        ina = 128'h1;
        inb = 128'h2;
        sel = 1'b0;
        #5;
        sel = 1'b1;
        #1;

        check_outputs(128'h1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large value select", test_num);
        ina = {64'hFFFFFFFFFFFFFFFF, 64'h0000000000000000};
        inb = {64'h0000000000000000, 64'hFFFFFFFFFFFFFFFF};
        sel = 1'b0;
        #1;

        check_outputs({64'h0000000000000000, 64'hFFFFFFFFFFFFFFFF});
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
        input [127:0] expected_out;
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
