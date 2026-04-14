`timescale 1ns/1ps

module mux_4to1_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [15:0] C;
    reg [15:0] D;
    reg [1:0] sel;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1 dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Input A (sel = 00)", test_num);
        A = 16'hAAAA;
        B = 16'h5555;
        C = 16'h1234;
        D = 16'hFFFF;
        sel = 2'b00;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Input B (sel = 01)", test_num);
        A = 16'h0000;
        B = 16'hBEEF;
        C = 16'hCAFE;
        D = 16'hABCD;
        sel = 2'b01;
        #1;

        check_outputs(16'hBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Input C (sel = 10)", test_num);
        A = 16'h1111;
        B = 16'h2222;
        C = 16'h3333;
        D = 16'h4444;
        sel = 2'b10;
        #1;

        check_outputs(16'h3333);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Input D (sel = 11)", test_num);
        A = 16'hF0F0;
        B = 16'h0F0F;
        C = 16'hCCCC;
        D = 16'hD00D;
        sel = 2'b11;
        #1;

        check_outputs(16'hD00D);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary - All Zeros", test_num);
        A = 16'h0000;
        B = 16'hFFFF;
        C = 16'hFFFF;
        D = 16'hFFFF;
        sel = 2'b00;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary - All Ones", test_num);
        A = 16'h0000;
        B = 16'h0000;
        C = 16'h0000;
        D = 16'hFFFF;
        sel = 2'b11;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Dynamic switching check", test_num);
        A = 16'h1234; B = 16'h5678; C = 16'h9ABC; D = 16'hDEF0;


        sel = 2'b10;
        #5;

        sel = 2'b01;
        #1;

        check_outputs(16'h5678);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4to1 Testbench");
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
        input [15:0] expected_out;
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
