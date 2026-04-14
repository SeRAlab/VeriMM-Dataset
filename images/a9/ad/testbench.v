`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk7_en;
    reg [15:0] data_in;
    reg dmal;
    reg dmas;
    reg [8:0] hpos;
    reg [7:0] reg_address_in;
    reg speed;
    reg turbo;
    wire [19:0] address_out;
    wire dma;
    wire [7:0] reg_address_out;
    wire wr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk7_en(clk7_en),
        .data_in(data_in),
        .dmal(dmal),
        .dmas(dmas),
        .hpos(hpos),
        .reg_address_in(reg_address_in),
        .speed(speed),
        .turbo(turbo),
        .address_out(address_out),
        .dma(dma),
        .reg_address_out(reg_address_out),
        .wr(wr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clk7_en = 0;
            data_in = 0;
            dmal = 0;
            dmas = 0;
            hpos = 0;
            reg_address_in = 0;
            speed = 0;
            turbo = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Idle State", test_num);
            reset_dut();

            hpos = 9'h000;
            repeat(10) @(posedge clk);


            #1;



            check_outputs(20'h0, 1'b0, 8'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: DMA Activation with Turbo", test_num);
            reset_dut();

            dmal = 1;
            turbo = 1;
            clk7_en = 1;
            hpos = 9'h020;

            repeat(5) @(posedge clk);



            #1;




            check_outputs(address_out, 1'b1, reg_address_out, wr);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Register Address Passthrough", test_num);
            reset_dut();

            reg_address_in = 8'hA5;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(address_out, dma, 8'hA5, wr);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: DMA Activation with Speed", test_num);
            reset_dut();

            dmas = 1;
            speed = 1;
            clk7_en = 1;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(address_out, 1'b1, reg_address_out, wr);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Address Load via Data In", test_num);
            reset_dut();

            data_in = 16'hBEEF;
            hpos = 9'h000;
            clk7_en = 1;
            repeat(5) @(posedge clk);



            if (address_out != 20'h0) begin
                $display("  Address out updated to: %h", address_out);
                pass_count = pass_count + 1;
            end else begin
                $display("  Address out failed to update.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Write Signal Generation", test_num);
            reset_dut();

            dmal = 1;
            turbo = 1;
            clk7_en = 1;


            for (integer i = 0; i < 64; i = i + 1) begin
                hpos = i;
                @(posedge clk);
            end




            #1;





            check_outputs(address_out, 1'b1, reg_address_out, wr);
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
        input [19:0] expected_address_out;
        input expected_dma;
        input [7:0] expected_reg_address_out;
        input expected_wr;
        begin
            if (expected_address_out === (expected_address_out ^ address_out ^ expected_address_out) &&
                expected_dma === (expected_dma ^ dma ^ expected_dma) &&
                expected_reg_address_out === (expected_reg_address_out ^ reg_address_out ^ expected_reg_address_out) &&
                expected_wr === (expected_wr ^ wr ^ expected_wr)) begin
                $display("PASS");
                $display("  Outputs: address_out=%h, dma=%b, reg_address_out=%h, wr=%b",
                         address_out, dma, reg_address_out, wr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address_out=%h, dma=%b, reg_address_out=%h, wr=%b",
                         expected_address_out, expected_dma, expected_reg_address_out, expected_wr);
                $display("  Got:      address_out=%h, dma=%b, reg_address_out=%h, wr=%b",
                         address_out, dma, reg_address_out, wr);
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
        $dumpvars(0,clk, clk7_en, data_in, dmal, dmas, hpos, reg_address_in, speed, turbo, address_out, dma, reg_address_out, wr);
    end

endmodule
