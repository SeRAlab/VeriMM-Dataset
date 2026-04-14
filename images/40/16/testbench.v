`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [15:0] C;
    reg [15:0] D;
    reg [1:0] sel;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .sel(sel),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Input A", test_num);
        A = 16'hAAAA;
        B = 16'hBBBB;
        C = 16'hCCCC;
        D = 16'hDDDD;
        sel = 2'b00;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Input B", test_num);
        A = 16'h1234;
        B = 16'h5678;
        C = 16'h9ABC;
        D = 16'hDEF0;
        sel = 2'b01;
        #1;

        check_outputs(16'h5678);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Input C", test_num);
        A = 16'hFFFF;
        B = 16'h0000;
        C = 16'h5555;
        D = 16'hAAAA;
        sel = 2'b10;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Input D", test_num);
        A = 16'h0001;
        B = 16'h0002;
        C = 16'h0004;
        D = 16'h0008;
        sel = 2'b11;
        #1;

        check_outputs(16'h0008);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Zeros on Port B", test_num);
        A = 16'hFFFF;
        B = 16'h0000;
        C = 16'hFFFF;
        D = 16'hFFFF;
        sel = 2'b01;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Ones on Port C", test_num);
        A = 16'h0000;
        B = 16'h0000;
        C = 16'hFFFF;
        D = 16'h0000;
        sel = 2'b10;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Switching select between identical inputs", test_num);
        A = 16'hDEAD;
        B = 16'hBEEF;
        C = 16'hCAFE;
        D = 16'hBABE;


        sel = 2'b00;
        #1;

        check_outputs(16'hDEAD);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Input data change while select remains constant", test_num);
        sel = 2'b11;
        A = 16'h0; B = 16'h0; C = 16'h0; D = 16'h1111;
        #5;
        D = 16'h2222;
        #1;

        check_outputs(16'h2222);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1 Testbench");
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
        input [15:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
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
