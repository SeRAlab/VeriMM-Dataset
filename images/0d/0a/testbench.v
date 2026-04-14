`timescale 1ns/1ps

module ECC_Point_Addition_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] X1;
    reg [31:0] X2;
    reg [31:0] Y1;
    reg [31:0] Y2;
    reg [31:0] Z1;
    reg [31:0] Z2;
    reg clk;
    reg rst;
    wire [31:0] X3;
    wire [31:0] Y3;
    wire [31:0] Z3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ECC_Point_Addition dut (
        .X1(X1),
        .X2(X2),
        .Y1(Y1),
        .Y2(Y2),
        .Z1(Z1),
        .Z2(Z2),
        .clk(clk),
        .rst(rst),
        .X3(X3),
        .Y3(Y3),
        .Z3(Z3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            X1 = 32'd0;
            Y1 = 32'd0;
            Z1 = 32'd0;
            X2 = 32'd0;
            Y2 = 32'd0;
            Z2 = 32'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition of distinct points", test_num);
            reset_dut();

            X1 = 32'h00000010;
            Y1 = 32'h00000020;
            Z1 = 32'h00000001;

            X2 = 32'h00000030;
            Y2 = 32'h00000040;
            Z2 = 32'h00000001;


            repeat(20) @(posedge clk);



            #1;




            check_outputs(32'h000000A5, 32'h000000B2, 32'h00000005);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Point Doubling", test_num);
            reset_dut();

            X1 = 32'h00000010;
            Y1 = 32'h00000020;
            Z1 = 32'h00000001;

            X2 = 32'h00000010;
            Y2 = 32'h00000020;
            Z2 = 32'h00000001;

            repeat(20) @(posedge clk);


            #1;



            check_outputs(32'h0000012C, 32'h000003E8, 32'h00000002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Point at Infinity", test_num);
            reset_dut();

            X1 = 32'h00000ABC;
            Y1 = 32'h00000DEF;
            Z1 = 32'h00000001;

            X2 = 32'h00000000;
            Y2 = 32'h00000001;
            Z2 = 32'h00000000;

            repeat(20) @(posedge clk);


            #1;



            check_outputs(32'h00000ABC, 32'h00000DEF, 32'h00000001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition of Inverse Points", test_num);
            reset_dut();

            X1 = 32'h00000050;
            Y1 = 32'h00000060;
            Z1 = 32'h00000001;

            X2 = 32'h00000050;
            Y2 = 32'hFFFFFF9F;
            Z2 = 32'h00000001;

            repeat(20) @(posedge clk);


            #1;



            check_outputs(32'h00000000, 32'h00000001, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Coordinate Values", test_num);
            reset_dut();
            X1 = 32'hFFFFFFFF;
            Y1 = 32'hEEEEEEEE;
            Z1 = 32'h00000001;
            X2 = 32'h11111111;
            Y2 = 32'h22222222;
            Z2 = 32'h00000001;

            repeat(20) @(posedge clk);


            #1;



            check_outputs(32'h76543210, 32'hFEDCBA98, 32'h0000000F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ECC_Point_Addition Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [31:0] expected_X3;
        input [31:0] expected_Y3;
        input [31:0] expected_Z3;
        begin
            if (expected_X3 === (expected_X3 ^ X3 ^ expected_X3) &&
                expected_Y3 === (expected_Y3 ^ Y3 ^ expected_Y3) &&
                expected_Z3 === (expected_Z3 ^ Z3 ^ expected_Z3)) begin
                $display("PASS");
                $display("  Outputs: X3=%h, Y3=%h, Z3=%h",
                         X3, Y3, Z3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X3=%h, Y3=%h, Z3=%h",
                         expected_X3, expected_Y3, expected_Z3);
                $display("  Got:      X3=%h, Y3=%h, Z3=%h",
                         X3, Y3, Z3);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,X1, X2, Y1, Y2, Z1, Z2, clk, rst, X3, Y3, Z3);
    end

endmodule
