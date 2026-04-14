`timescale 1ns/1ps

module busdelay_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg i_dly_ack;
    reg [31:0] i_dly_data;
    reg i_dly_err;
    reg i_dly_stall;
    reg [31:0] i_wb_addr;
    reg i_wb_cyc;
    reg [31:0] i_wb_data;
    reg i_wb_stb;
    reg i_wb_we;
    wire [31:0] o_dly_addr;
    wire o_dly_cyc;
    wire [31:0] o_dly_data;
    wire o_dly_stb;
    wire o_dly_we;
    wire o_wb_ack;
    wire [31:0] o_wb_data;
    wire o_wb_err;
    wire o_wb_stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    busdelay dut (
        .i_clk(i_clk),
        .i_dly_ack(i_dly_ack),
        .i_dly_data(i_dly_data),
        .i_dly_err(i_dly_err),
        .i_dly_stall(i_dly_stall),
        .i_wb_addr(i_wb_addr),
        .i_wb_cyc(i_wb_cyc),
        .i_wb_data(i_wb_data),
        .i_wb_stb(i_wb_stb),
        .i_wb_we(i_wb_we),
        .o_dly_addr(o_dly_addr),
        .o_dly_cyc(o_dly_cyc),
        .o_dly_data(o_dly_data),
        .o_dly_stb(o_dly_stb),
        .o_dly_we(o_dly_we),
        .o_wb_ack(o_wb_ack),
        .o_wb_data(o_wb_data),
        .o_wb_err(o_wb_err),
        .o_wb_stall(o_wb_stall)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_wb_cyc   <= 0;
            i_wb_stb   <= 0;
            i_wb_we    <= 0;
            i_wb_addr  <= 0;
            i_wb_data  <= 0;
            i_dly_ack  <= 0;
            i_dly_stall<= 0;
            i_dly_data <= 0;
            i_dly_err  <= 0;
            repeat(2) @(posedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(posedge i_clk);
            i_wb_cyc  <= 1;
            i_wb_stb  <= 1;
            i_wb_we   <= 1;
            i_wb_addr <= 32'hAAAA_BBBB;
            i_wb_data <= 32'h1234_5678;

            @(posedge i_clk);
            #1;


            #1;



            check_outputs(
                32'hAAAA_BBBB,
                1,
                32'h1234_5678,
                1,
                1,
                0,
                32'h0,
                0,
                0
            );
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(posedge i_clk);
            i_dly_ack  <= 1;
            i_dly_data <= 32'hCAFE_BABE;

            @(posedge i_clk);
            #1;

            #1;


            check_outputs(
                32'h0,
                0,
                32'h0,
                0,
                0,
                1,
                32'hCAFE_BABE,
                0,
                0
            );
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(posedge i_clk);
            i_dly_err <= 1;

            @(posedge i_clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(posedge i_clk);
            i_dly_stall <= 1;

            @(posedge i_clk);
            #1;


            #1;



            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            @(posedge i_clk);
            i_wb_cyc  <= 1;
            i_wb_stb  <= 1;
            i_wb_we   <= 0;
            i_wb_addr <= 32'h0000_1111;


            @(posedge i_clk);
            i_dly_ack  <= 1;
            i_dly_data <= 32'h8765_4321;


            @(posedge i_clk);
            #1;
            #1;

            check_outputs(
                32'h0000_1111,
                1,
                32'h0,
                1,
                0,
                1,
                32'h8765_4321,
                0,
                0
            );
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            repeat(3) @(posedge i_clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("busdelay Testbench");
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
        input [31:0] expected_o_dly_addr;
        input expected_o_dly_cyc;
        input [31:0] expected_o_dly_data;
        input expected_o_dly_stb;
        input expected_o_dly_we;
        input expected_o_wb_ack;
        input [31:0] expected_o_wb_data;
        input expected_o_wb_err;
        input expected_o_wb_stall;
        begin
            if (expected_o_dly_addr === (expected_o_dly_addr ^ o_dly_addr ^ expected_o_dly_addr) &&
                expected_o_dly_cyc === (expected_o_dly_cyc ^ o_dly_cyc ^ expected_o_dly_cyc) &&
                expected_o_dly_data === (expected_o_dly_data ^ o_dly_data ^ expected_o_dly_data) &&
                expected_o_dly_stb === (expected_o_dly_stb ^ o_dly_stb ^ expected_o_dly_stb) &&
                expected_o_dly_we === (expected_o_dly_we ^ o_dly_we ^ expected_o_dly_we) &&
                expected_o_wb_ack === (expected_o_wb_ack ^ o_wb_ack ^ expected_o_wb_ack) &&
                expected_o_wb_data === (expected_o_wb_data ^ o_wb_data ^ expected_o_wb_data) &&
                expected_o_wb_err === (expected_o_wb_err ^ o_wb_err ^ expected_o_wb_err) &&
                expected_o_wb_stall === (expected_o_wb_stall ^ o_wb_stall ^ expected_o_wb_stall)) begin
                $display("PASS");
                $display("  Outputs: o_dly_addr=%h, o_dly_cyc=%b, o_dly_data=%h, o_dly_stb=%b, o_dly_we=%b, o_wb_ack=%b, o_wb_data=%h, o_wb_err=%b, o_wb_stall=%b",
                         o_dly_addr, o_dly_cyc, o_dly_data, o_dly_stb, o_dly_we, o_wb_ack, o_wb_data, o_wb_err, o_wb_stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_dly_addr=%h, o_dly_cyc=%b, o_dly_data=%h, o_dly_stb=%b, o_dly_we=%b, o_wb_ack=%b, o_wb_data=%h, o_wb_err=%b, o_wb_stall=%b",
                         expected_o_dly_addr, expected_o_dly_cyc, expected_o_dly_data, expected_o_dly_stb, expected_o_dly_we, expected_o_wb_ack, expected_o_wb_data, expected_o_wb_err, expected_o_wb_stall);
                $display("  Got:      o_dly_addr=%h, o_dly_cyc=%b, o_dly_data=%h, o_dly_stb=%b, o_dly_we=%b, o_wb_ack=%b, o_wb_data=%h, o_wb_err=%b, o_wb_stall=%b",
                         o_dly_addr, o_dly_cyc, o_dly_data, o_dly_stb, o_dly_we, o_wb_ack, o_wb_data, o_wb_err, o_wb_stall);
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
        $dumpvars(0,i_clk, i_dly_ack, i_dly_data, i_dly_err, i_dly_stall, i_wb_addr, i_wb_cyc, i_wb_data, i_wb_stb, i_wb_we, o_dly_addr, o_dly_cyc, o_dly_data, o_dly_stb, o_dly_we, o_wb_ack, o_wb_data, o_wb_err, o_wb_stall);
    end

endmodule
