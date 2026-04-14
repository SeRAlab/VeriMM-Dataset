`timescale 1ns/1ps

module sum_of_products_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg rst;
    wire [15:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sum_of_products dut (
        .A(A),
        .B(B),
        .clk(clk),
        .rst(rst),
        .Z(Z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            A = 0;
            B = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset check (Z should be 0)", test_num);
            reset_dut();

            #1;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single product (12 * 5)", test_num);
            reset_dut();
            A = 8'd12;
            B = 8'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd60);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Accumulate three products (10*2 + 5*4 + 3*3)", test_num);
            reset_dut();

            A = 8'd10; B = 8'd2;
            @(posedge clk);

            A = 8'd5; B = 8'd4;
            @(posedge clk);

            A = 8'd3; B = 8'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd49);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiplying by zero and large values (250*40 + 0*255 + 100*0)", test_num);
            reset_dut();

            A = 8'd250; B = 8'd40;
            @(posedge clk);

            A = 8'd0; B = 8'd255;
            @(posedge clk);

            A = 8'd100; B = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd10000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 16-bit Overflow (Sum exceeding 65535)", test_num);
            reset_dut();

            A = 8'd255; B = 8'd255;
            @(posedge clk);


            A = 8'd10; B = 8'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd489);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum 8-bit inputs product", test_num);
            reset_dut();
            A = 8'hFF;
            B = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Accumulation should hold value when adding 0*0", test_num);
            reset_dut();
            A = 8'd50; B = 8'd2;
            @(posedge clk);
            A = 8'd0; B = 8'd0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sum_of_products Testbench");
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
        input [15:0] expected_Z;
        begin
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
        $dumpvars(0,A, B, clk, rst, Z);
    end

endmodule
