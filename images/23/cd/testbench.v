`timescale 1ns/1ps

module spi_master_tb;

    // Testbench signals (sequential circuit)
    reg MISO;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start;
    wire CS;
    wire MOSI;
    wire SCK;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_master dut (
        .MISO(MISO),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .CS(CS),
        .MOSI(MOSI),
        .SCK(SCK),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            data_in = 8'h00;
            MISO = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task simulate_slave_response;

        input [7:0] response_data;
        integer i;
        begin

            wait (CS == 0);
            for (i = 7; i >= 0; i = i - 1) begin


                MISO = response_data[i];
                @(posedge SCK);
            end

            wait (CS == 1);
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Transmission 0xA5 (Master) -> 0x5A (Slave)", test_num);
            reset_dut();

            data_in = 8'hA5;
            start = 1;
            @(posedge clk);
            start = 0;


            simulate_slave_response(8'h5A);




            #1;





            check_outputs(1'b1, MOSI, 1'b0, 8'h5A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmission with All Zeros", test_num);
            reset_dut();

            data_in = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;

            simulate_slave_response(8'h00);

            #1;


            check_outputs(1'b1, MOSI, 1'b0, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmission with All Ones", test_num);
            reset_dut();

            data_in = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;

            simulate_slave_response(8'hFF);

            #1;


            check_outputs(1'b1, MOSI, 1'b1, 1'b0, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 0xAA -> 0x55", test_num);
            reset_dut();

            data_in = 8'hAA;
            start = 1;
            @(posedge clk);
            start = 0;

            simulate_slave_response(8'h55);

            #1;


            check_outputs(1'b1, MOSI, 1'b0, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify back-to-back transmissions", test_num);
            reset_dut();


            data_in = 8'h12;
            start = 1;
            @(posedge clk);
            start = 0;
            simulate_slave_response(8'hFE);


            #50;
            data_in = 8'h34;
            start = 1;
            @(posedge clk);
            start = 0;
            simulate_slave_response(8'hDC);

            #1;


            check_outputs(1'b1, MOSI, 1'b0, 8'hDC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_master Testbench");
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
        input expected_CS;
        input expected_MOSI;
        input expected_SCK;
        input [7:0] expected_data_out;
        begin
            if (expected_CS === (expected_CS ^ CS ^ expected_CS) &&
                expected_MOSI === (expected_MOSI ^ MOSI ^ expected_MOSI) &&
                expected_SCK === (expected_SCK ^ SCK ^ expected_SCK) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: CS=%b, MOSI=%b, SCK=%b, data_out=%h",
                         CS, MOSI, SCK, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CS=%b, MOSI=%b, SCK=%b, data_out=%h",
                         expected_CS, expected_MOSI, expected_SCK, expected_data_out);
                $display("  Got:      CS=%b, MOSI=%b, SCK=%b, data_out=%h",
                         CS, MOSI, SCK, data_out);
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
        $dumpvars(0,MISO, clk, data_in, reset, start, CS, MOSI, SCK, data_out);
    end

endmodule
