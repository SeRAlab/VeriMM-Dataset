`timescale 1ns/1ps

module mux2to1_32_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg sel;
    wire [31:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux2to1_32 dut (
        .a(a),
        .b(b),
        .sel(sel),
        .o(o)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select A (Simple Value)", test_num);
        a = 32'h00000001;
        b = 32'h00000002;
        sel = 1'b0;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select B (Simple Value)", test_num);
        a = 32'h00000001;
        b = 32'h00000002;
        sel = 1'b1;
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select A (Hex Pattern)", test_num);
        a = 32'hDEADBEEF;
        b = 32'hCAFEBABE;
        sel = 1'b0;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select B (Hex Pattern)", test_num);
        a = 32'hDEADBEEF;
        b = 32'hCAFEBABE;
        sel = 1'b1;
        #1;

        check_outputs(32'hCAFEBABE);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select A (All Ones vs Zeros)", test_num);
        a = 32'hFFFFFFFF;
        b = 32'h00000000;
        sel = 1'b0;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select B (All Ones vs Zeros)", test_num);
        a = 32'hFFFFFFFF;
        b = 32'h00000000;
        sel = 1'b1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select A (Alternating Bits)", test_num);
        a = 32'hAAAAAAAA;
        b = 32'h55555555;
        sel = 1'b0;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select B (Alternating Bits)", test_num);
        a = 32'hAAAAAAAA;
        b = 32'h55555555;
        sel = 1'b1;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux2to1_32 Testbench");
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
        input [31:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
