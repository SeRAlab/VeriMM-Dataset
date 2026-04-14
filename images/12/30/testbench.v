`timescale 1ns/1ps

module GPIO_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    GPIO_Controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            we = 0;
            data_in = 8'h00;
            @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read", test_num);

            @(posedge clk);
            we = 1;
            data_in = 8'hA5;
            @(posedge clk);
            we = 0;
            @(posedge clk);

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Verification", test_num);

            @(posedge clk);
            we = 1;
            data_in = 8'hFF;
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;
            we = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Enable Inhibit", test_num);


            @(posedge clk);
            we = 1;
            data_in = 8'h55;
            @(posedge clk);


            we = 0;
            data_in = 8'hAA;
            @(posedge clk);
            @(posedge clk);


            #1;



            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Successive Writes", test_num);

            @(posedge clk);
            we = 1;
            data_in = 8'h01;
            @(posedge clk);
            data_in = 8'h02;
            @(posedge clk);
            data_in = 8'h04;
            @(posedge clk);
            data_in = 8'h08;
            @(posedge clk);
            we = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h08);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Bits Toggle", test_num);

            @(posedge clk);
            we = 1;
            data_in = 8'hFF;
            @(posedge clk);
            data_in = 8'h00;
            @(posedge clk);
            data_in = 8'hAA;
            @(posedge clk);
            we = 0;
            @(posedge clk);

            #1;


            check_outputs(8'hAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("GPIO_Controller Testbench");
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, rst, we, data_out);
    end

endmodule
