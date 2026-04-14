`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire data_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .cs(cs),
        .data_in(data_in),
        .data_out(data_out),
        .data_valid(data_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            cs = 1;
            data_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Transmit 0xA5", test_num);
            reset_dut();


            cs = 0;
            data_in = 8'hA5;



            wait(data_valid == 1);
            #1;

            #1;


            check_outputs(8'hA5, 1'b1);

            cs = 1;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Transmit 0x5A", test_num);
            reset_dut();

            cs = 0;
            data_in = 8'h5A;

            wait(data_valid == 1);
            #1;

            #1;


            check_outputs(8'h5A, 1'b1);

            cs = 1;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Transmit All Ones (0xFF)", test_num);
            reset_dut();

            cs = 0;
            data_in = 8'hFF;

            wait(data_valid == 1);
            #1;

            #1;


            check_outputs(8'hFF, 1'b1);

            cs = 1;
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Transmit All Zeros (0x00)", test_num);
            reset_dut();

            cs = 0;
            data_in = 8'h00;

            wait(data_valid == 1);
            #1;

            #1;


            check_outputs(8'h00, 1'b1);

            cs = 1;
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Sequential Transmit 0x12 then 0x34", test_num);
            reset_dut();


            cs = 0;
            data_in = 8'h12;
            wait(data_valid == 1);
            #1;



            cs = 1;
            @(posedge clk);
            cs = 0;
            data_in = 8'h34;
            wait(data_valid == 1);
            #1;

            #1;


            check_outputs(8'h34, 1'b1);

            cs = 1;
            @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_controller Testbench");
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
        input expected_data_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_valid === (expected_data_valid ^ data_valid ^ expected_data_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_valid=%b",
                         data_out, data_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_valid=%b",
                         expected_data_out, expected_data_valid);
                $display("  Got:      data_out=%h, data_valid=%b",
                         data_out, data_valid);
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
        $dumpvars(0,clk, cs, data_in, data_out, data_valid);
    end

endmodule
