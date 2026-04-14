`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg miso;
    reg reset;
    wire [7:0] data_out;
    wire mosi;
    wire sclk;
    wire ss;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .miso(miso),
        .reset(reset),
        .data_out(data_out),
        .mosi(mosi),
        .sclk(sclk),
        .ss(ss)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            data_in = 8'h0;
            miso = 0;
            repeat(2) @(posedge clk);
            #2 reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task simulate_slave_response;

        input [7:0] to_slave_val;
        input [7:0] from_slave_val;
        integer i;
        begin

            wait(ss == 0);


            miso = from_slave_val[7];

            for (i = 6; i >= 0; i = i - 1) begin

                @(negedge sclk);
                miso = from_slave_val[i];
            end


            wait(ss == 1);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Sending 0xA5, Expecting 0x5A", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hA5;
            enable = 1;
            @(posedge clk);
            enable = 0;


            simulate_slave_response(8'hA5, 8'h5A);


            repeat(5) @(posedge clk);



            #1;




            check_outputs(8'h5A, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Sending 0x00, Expecting 0xFF", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'h00;
            enable = 1;
            @(posedge clk);
            enable = 0;

            simulate_slave_response(8'h00, 8'hFF);

            repeat(5) @(posedge clk);


            #1;



            check_outputs(8'hFF, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Sending 0xFF, Expecting 0x00", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hFF;
            enable = 1;
            @(posedge clk);
            enable = 0;

            simulate_slave_response(8'hFF, 8'h00);

            repeat(5) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Sequential Transmission (0x12 then 0x34)", test_num);
            reset_dut();


            @(posedge clk);
            data_in = 8'h12;
            enable = 1;
            @(posedge clk);
            enable = 0;
            simulate_slave_response(8'h12, 8'hCC);
            repeat(5) @(posedge clk);


            @(posedge clk);
            data_in = 8'h34;
            enable = 1;
            @(posedge clk);
            enable = 0;
            simulate_slave_response(8'h34, 8'h77);

            repeat(5) @(posedge clk);


            #1;



            check_outputs(8'h77, 1'b0, 1'b0, 1'b1);
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
        input [7:0] expected_data_out;
        input expected_mosi;
        input expected_sclk;
        input expected_ss;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_sclk === (expected_sclk ^ sclk ^ expected_sclk) &&
                expected_ss === (expected_ss ^ ss ^ expected_ss)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, mosi=%b, sclk=%b, ss=%b",
                         data_out, mosi, sclk, ss);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, mosi=%b, sclk=%b, ss=%b",
                         expected_data_out, expected_mosi, expected_sclk, expected_ss);
                $display("  Got:      data_out=%h, mosi=%b, sclk=%b, ss=%b",
                         data_out, mosi, sclk, ss);
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
        $dumpvars(0,clk, data_in, enable, miso, reset, data_out, mosi, sclk, ss);
    end

endmodule
