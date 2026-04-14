`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg start;
    wire done;
    wire mosi;
    wire sck;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .data_in(data_in),
        .start(start),
        .done(done),
        .mosi(mosi),
        .sck(sck)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmitting 8'hA5 (10100101)", test_num);
            reset_dut();

            data_in = 8'hA5;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmitting 8'h00", test_num);
            reset_dut();

            data_in = 8'h00;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmitting 8'hFF", test_num);
            reset_dut();

            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transmitting 8'h5A (01011010)", test_num);
            reset_dut();

            data_in = 8'h5A;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0, 1'b0);
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
        input expected_done;
        input expected_mosi;
        input expected_sck;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_sck === (expected_sck ^ sck ^ expected_sck)) begin
                $display("PASS");
                $display("  Outputs: done=%b, mosi=%b, sck=%b",
                         done, mosi, sck);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, mosi=%b, sck=%b",
                         expected_done, expected_mosi, expected_sck);
                $display("  Got:      done=%b, mosi=%b, sck=%b",
                         done, mosi, sck);
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
        $dumpvars(0,clk, data_in, start, done, mosi, sck);
    end

endmodule
