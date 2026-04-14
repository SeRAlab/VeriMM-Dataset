`timescale 1ns/1ps

module mux2to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [7:0] in1;
    reg sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux2to1 dut (
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        in0 = 8'hAA;
        in1 = 8'h55;
        sel = 1'b0;
        $display("Test Case %0d: sel=0, in0=0xAA, in1=0x55", test_num);
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        in0 = 8'hAA;
        in1 = 8'h55;
        sel = 1'b1;
        $display("Test Case %0d: sel=1, in0=0xAA, in1=0x55", test_num);
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        in0 = 8'h00;
        in1 = 8'hFF;
        sel = 1'b0;
        $display("Test Case %0d: sel=0, in0=0x00, in1=0xFF", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        in0 = 8'h00;
        in1 = 8'hFF;
        sel = 1'b1;
        $display("Test Case %0d: sel=1, in0=0x00, in1=0xFF", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        in0 = 8'h01;
        in1 = 8'h80;
        sel = 1'b0;
        $display("Test Case %0d: sel=0, walking ones", test_num);
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        in0 = 8'h01;
        in1 = 8'h80;
        sel = 1'b1;
        $display("Test Case %0d: sel=1, walking ones", test_num);
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        in0 = 8'h3C;
        in1 = 8'hC3;
        sel = 1'b0;
        #2;
        sel = 1'b1;
        $display("Test Case %0d: Dynamic select toggle to in1", test_num);
        #1;

        check_outputs(8'hC3);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        in0 = 8'hE7;
        in1 = 8'hE7;
        sel = 1'b0;
        #1;
        sel = 1'b1;
        $display("Test Case %0d: Identical inputs (0xE7)", test_num);
        #1;

        check_outputs(8'hE7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux2to1 Testbench");
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
        input [7:0] expected_out;
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
