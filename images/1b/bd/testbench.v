`timescale 1ns/1ps

module ECC_Point_Addition_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [31:0] x1;
    reg [31:0] x2;
    reg [31:0] y1;
    reg [31:0] y2;
    wire valid;
    wire [31:0] x3;
    wire [31:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ECC_Point_Addition dut (
        .clk(clk),
        .rst(rst),
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .valid(valid),
        .x3(x3),
        .y3(y3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x1 = 32'h0;
            y1 = 32'h0;
            x2 = 32'h0;
            y2 = 32'h0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition with P1 as Infinity", test_num);


            x1 = 32'h00000000;
            y1 = 32'h00000000;
            x2 = 32'h00000003;
            y2 = 32'h0000000A;

            wait(valid);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 32'h00000003, 32'h0000000A);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition with P2 as Infinity", test_num);


            x1 = 32'h00000003;
            y1 = 32'h0000000A;
            x2 = 32'h00000000;
            y2 = 32'h00000000;

            wait(valid);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 32'h00000003, 32'h0000000A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Standard Addition (P + Q)", test_num);



            x1 = 32'h00000003;
            y1 = 32'h0000000A;
            x2 = 32'h00000009;
            y2 = 32'h00000007;

            wait(valid);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 32'h0000000B, 32'h00000003);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Point Doubling (P + P)", test_num);


            x1 = 32'h00000003;
            y1 = 32'h0000000A;
            x2 = 32'h00000003;
            y2 = 32'h0000000A;

            wait(valid);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 32'h00000007, 32'h0000000C);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Point Inverse (P + -P)", test_num);


            x1 = 32'h00000003;
            y1 = 32'h0000000A;
            x2 = 32'h00000003;
            y2 = 32'h0000000D;

            wait(valid);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 32'h00000000, 32'h00000000);
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
        input expected_valid;
        input [31:0] expected_x3;
        input [31:0] expected_y3;
        begin
            if (expected_valid === (expected_valid ^ valid ^ expected_valid) &&
                expected_x3 === (expected_x3 ^ x3 ^ expected_x3) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: valid=%b, x3=%h, y3=%h",
                         valid, x3, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid=%b, x3=%h, y3=%h",
                         expected_valid, expected_x3, expected_y3);
                $display("  Got:      valid=%b, x3=%h, y3=%h",
                         valid, x3, y3);
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
        $dumpvars(0,clk, rst, x1, x2, y1, y2, valid, x3, y3);
    end

endmodule
