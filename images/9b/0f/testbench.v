`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Rz;
    reg [3:0] X;
    reg [3:0] Y;
    reg [3:0] Z;
    reg rst;
    reg rw;
    wire [31:0] Rx;
    wire [31:0] Ry;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Rz(Rz),
        .X(X),
        .Y(Y),
        .Z(Z),
        .rst(rst),
        .rw(rw),
        .Rx(Rx),
        .Ry(Ry)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Reset Values", test_num);


        rst = 1;
        rw = 0;
        Rz = 0;
        X = 0;
        Y = 0;
        Z = 0;
        #10;
        rst = 0;
        #10;


        X = 4'd5;
        Y = 4'd12;


        #1;



        check_outputs(32'd5, 32'd12);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write and Read back", test_num);


        rst = 1;
        #10;
        rst = 0;
        #10;


        rw = 1;
        Z = 4'd8;
        Rz = 32'hDEADBEEF;
        #10;
        rw = 0;


        X = 4'd8;
        Y = 4'd0;


        #1;



        check_outputs(32'hDEADBEEF, 32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify rw=0 prevents writing", test_num);


        rst = 1;
        #10;
        rst = 0;
        #10;


        rw = 0;
        Z = 4'd3;
        Rz = 32'hCAFEBABE;
        #10;


        X = 4'd3;
        Y = 4'd3;


        #1;



        check_outputs(32'd3, 32'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Index Check (0 and 15)", test_num);


        rst = 1;
        #10;
        rst = 0;
        #10;


        rw = 1;
        Z = 4'd0;
        Rz = 32'h11112222;
        #10;


        Z = 4'd15;
        Rz = 32'hAAAA5555;
        #10;
        rw = 0;


        X = 4'd0;
        Y = 4'd15;


        #1;



        check_outputs(32'h11112222, 32'hAAAA5555);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simultaneous read from same address", test_num);


        rst = 1;
        #10;
        rst = 0;
        #10;


        rw = 1;
        Z = 4'd7;
        Rz = 32'h12345678;
        #10;
        rw = 0;


        X = 4'd7;
        Y = 4'd7;


        #1;



        check_outputs(32'h12345678, 32'h12345678);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset overrides previous data", test_num);


        rst = 1; #10; rst = 0; #10;


        rw = 1;
        Z = 4'd10;
        Rz = 32'hFFFFFFFF;
        #10;
        rw = 0;


        rst = 1;
        #10;
        rst = 0;
        #10;


        X = 4'd10;
        Y = 4'd1;


        #1;



        check_outputs(32'd10, 32'd1);
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
        input [31:0] expected_Rx;
        input [31:0] expected_Ry;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Rx === (expected_Rx ^ Rx ^ expected_Rx) &&
                expected_Ry === (expected_Ry ^ Ry ^ expected_Ry)) begin
                $display("PASS");
                $display("  Outputs: Rx=%h, Ry=%h",
                         Rx, Ry);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Rx=%h, Ry=%h",
                         expected_Rx, expected_Ry);
                $display("  Got:      Rx=%h, Ry=%h",
                         Rx, Ry);
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
