`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ADR;
    reg [15:0] D0i;
    reg [15:0] D1i;
    reg [15:0] D2i;
    reg [15:0] D3i;
    reg [15:0] D4i;
    reg [15:0] D5i;
    reg [15:0] D6i;
    reg [15:0] D7i;
    wire [15:0] Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADR(ADR),
        .D0i(D0i),
        .D1i(D1i),
        .D2i(D2i),
        .D3i(D3i),
        .D4i(D4i),
        .D5i(D5i),
        .D6i(D6i),
        .D7i(D7i),
        .Dout(Dout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Selecting D0i", test_num);
        D0i = 16'hAAAA; D1i = 16'h0000; D2i = 16'h0000; D3i = 16'h0000;
        D4i = 16'h0000; D5i = 16'h0000; D6i = 16'h0000; D7i = 16'h0000;
        ADR = 3'b000;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Selecting D1i", test_num);
        D0i = 16'h0000; D1i = 16'h5555; D2i = 16'h0000; D3i = 16'h0000;
        D4i = 16'h0000; D5i = 16'h0000; D6i = 16'h0000; D7i = 16'h0000;
        ADR = 3'b001;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Selecting D2i", test_num);
        D0i = 16'h0000; D1i = 16'h0000; D2i = 16'h1234; D3i = 16'h0000;
        D4i = 16'h0000; D5i = 16'h0000; D6i = 16'h0000; D7i = 16'h0000;
        ADR = 3'b010;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Selecting D3i", test_num);
        D0i = 16'h0000; D1i = 16'h0000; D2i = 16'h0000; D3i = 16'hABCD;
        D4i = 16'h0000; D5i = 16'h0000; D6i = 16'h0000; D7i = 16'h0000;
        ADR = 3'b011;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Selecting D4i", test_num);
        D0i = 16'h0000; D1i = 16'h0000; D2i = 16'h0000; D3i = 16'h0000;
        D4i = 16'hFFFF; D5i = 16'h0000; D6i = 16'h0000; D7i = 16'h0000;
        ADR = 3'b100;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Selecting D5i", test_num);
        D0i = 16'h0000; D1i = 16'h0000; D2i = 16'h0000; D3i = 16'h0000;
        D4i = 16'h0000; D5i = 16'h8001; D6i = 16'h0000; D7i = 16'h0000;
        ADR = 3'b101;
        #1;

        check_outputs(16'h8001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Selecting D6i", test_num);
        D0i = 16'h1111; D1i = 16'h2222; D2i = 16'h3333; D3i = 16'h4444;
        D4i = 16'h5555; D5i = 16'h6666; D6i = 16'h7777; D7i = 16'h8888;
        ADR = 3'b110;
        #1;

        check_outputs(16'h7777);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Selecting D7i", test_num);
        D0i = 16'hFFFF; D1i = 16'hEEEE; D2i = 16'hDDDD; D3i = 16'hCCCC;
        D4i = 16'hBBBB; D5i = 16'hAAAA; D6i = 16'h9999; D7i = 16'h1234;
        ADR = 3'b111;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Verify cross-talk (changing unselected input)", test_num);

        D0i = 16'h0000; D1i = 16'h0000; D2i = 16'hCAFE; D3i = 16'h0000;
        D4i = 16'h0000; D5i = 16'h0000; D6i = 16'h0000; D7i = 16'h0000;
        ADR = 3'b010;
        #5;

        D0i = 16'hFFFF;
        #1;

        check_outputs(16'hCAFE);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Verify all zero inputs", test_num);
        D0i = 16'h0; D1i = 16'h0; D2i = 16'h0; D3i = 16'h0;
        D4i = 16'h0; D5i = 16'h0; D6i = 16'h0; D7i = 16'h0;
        ADR = 3'b101;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_Dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Dout === (expected_Dout ^ Dout ^ expected_Dout)) begin
                $display("PASS");
                $display("  Outputs: Dout=%h",
                         Dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dout=%h",
                         expected_Dout);
                $display("  Got:      Dout=%h",
                         Dout);
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
