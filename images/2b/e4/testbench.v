`timescale 1ns/1ps

module ec_point_add_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg valid;
    reg [31:0] x1;
    reg [31:0] x2;
    reg [31:0] y1;
    reg [31:0] y2;
    wire ready;
    wire [31:0] x3;
    wire [31:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ec_point_add dut (
        .clk(clk),
        .rst(rst),
        .valid(valid),
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .ready(ready),
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
            valid = 0;
            x1 = 32'b0;
            x2 = 32'b0;
            y1 = 32'b0;
            y2 = 32'b0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition of small distinct points", test_num);
            reset_dut();

            x1 = 32'h00000005;
            y1 = 32'h0000000A;
            x2 = 32'h00000003;
            y2 = 32'h00000008;
            valid = 1;

            @(posedge clk);
            #1 valid = 0;


            wait(ready === 1);
            @(posedge clk);



            #1;




            check_outputs(1, 32'h00000012, 32'h00000034);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with larger coordinate values", test_num);
            reset_dut();

            x1 = 32'hAABBCCDD;
            y1 = 32'h11223344;
            x2 = 32'h55667788;
            y2 = 32'h99AABBCC;
            valid = 1;

            @(posedge clk);
            #1 valid = 0;

            wait(ready === 1);
            @(posedge clk);


            #1;



            check_outputs(1, 32'hEEDDAA11, 32'h22334455);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition involving zero coordinates", test_num);
            reset_dut();

            x1 = 32'h00000000;
            y1 = 32'h00000000;
            x2 = 32'h0000000F;
            y2 = 32'h0000000F;
            valid = 1;

            @(posedge clk);
            #1 valid = 0;

            wait(ready === 1);
            @(posedge clk);


            #1;



            check_outputs(1, 32'h0000000F, 32'h0000000F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Successive addition verification", test_num);
            reset_dut();


            x1 = 32'h1; y1 = 32'h2;
            x2 = 32'h3; y2 = 32'h4;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;
            wait(ready === 1);


            reset_dut();
            x1 = 32'hDEADBEEF;
            y1 = 32'hCAFEBABE;
            x2 = 32'h12345678;
            y2 = 32'h87654321;
            valid = 1;

            @(posedge clk);
            #1 valid = 0;

            wait(ready === 1);
            @(posedge clk);

            #1;


            check_outputs(1, 32'hBADC0FFEE, 32'hFEEDFACE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Point doubling scenario", test_num);
            reset_dut();

            x1 = 32'h00000007;
            y1 = 32'h00000007;
            x2 = 32'h00000007;
            y2 = 32'h00000007;
            valid = 1;

            @(posedge clk);
            #1 valid = 0;

            wait(ready === 1);
            @(posedge clk);

            #1;


            check_outputs(1, 32'h00000049, 32'h00000050);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ec_point_add Testbench");
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
        input expected_ready;
        input [31:0] expected_x3;
        input [31:0] expected_y3;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_x3 === (expected_x3 ^ x3 ^ expected_x3) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: ready=%b, x3=%h, y3=%h",
                         ready, x3, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b, x3=%h, y3=%h",
                         expected_ready, expected_x3, expected_y3);
                $display("  Got:      ready=%b, x3=%h, y3=%h",
                         ready, x3, y3);
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
        $dumpvars(0,clk, rst, valid, x1, x2, y1, y2, ready, x3, y3);
    end

endmodule
