`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] datain;
    reg loaden;
    reg rstn;
    reg unloaden;
    wire [63:0] dataout;
    wire empty;
    wire full;
    wire [5:0] itemsinfifo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datain(datain),
        .loaden(loaden),
        .rstn(rstn),
        .unloaden(unloaden),
        .dataout(dataout),
        .empty(empty),
        .full(full),
        .itemsinfifo(itemsinfifo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            loaden = 0;
            unloaden = 0;
            datain = 0;
            repeat(2) @(posedge clk);
            #1 rstn = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(64'bx, 1'b1, 1'b0, 6'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            loaden = 1;
            datain = 64'hDEADBEEFCAFEBABE;
            @(posedge clk);
            #1;
            loaden = 0;


            #1;



            check_outputs(64'hDEADBEEFCAFEBABE, 1'b0, 1'b0, 6'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk);
            #1;
            loaden = 1;
            datain = 64'h1122334455667788;
            @(posedge clk);
            #1;
            loaden = 0;
            unloaden = 1;
            @(posedge clk);
            #1;
            unloaden = 0;

            #1;


            check_outputs(64'h1122334455667788, 1'b1, 1'b0, 6'd0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            for (i = 0; i < 64; i = i + 1) begin
                @(posedge clk);
                #1;
                loaden = 1;
                datain = i + 1;
            end
            @(posedge clk);
            #1;
            loaden = 0;

            #1;


            check_outputs(64'h1, 1'b0, 1'b1, 6'd0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();

            for (i = 0; i < 64; i = i + 1) begin
                @(posedge clk);
                #1;
                loaden = 1;
                datain = i + 1;
            end
            @(posedge clk);

            #1;
            loaden = 1;
            datain = 64'hFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #1;
            loaden = 0;

            #1;


            check_outputs(64'h1, 1'b0, 1'b1, 6'd0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            reset_dut();

            for (i = 0; i < 64; i = i + 1) begin
                @(posedge clk);
                #1;
                loaden = 1;
                datain = i + 1;
            end
            @(posedge clk);
            #1;
            loaden = 0;

            for (i = 0; i < 64; i = i + 1) begin
                unloaden = 1;
                @(posedge clk);
                #1;
            end
            unloaden = 0;

            #1;


            check_outputs(64'h40, 1'b1, 1'b0, 6'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            repeat(5) begin
                @(posedge clk);
                #1;
                loaden = 1;
                datain = datain + 1;
            end
            @(posedge clk);
            #1;

            loaden = 1;
            unloaden = 1;
            datain = 64'hABC;
            @(posedge clk);
            #1;
            loaden = 0;
            unloaden = 0;

            #1;


            check_outputs(64'h2, 1'b0, 1'b0, 6'd5);
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
        input [63:0] expected_dataout;
        input expected_empty;
        input expected_full;
        input [5:0] expected_itemsinfifo;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_itemsinfifo === (expected_itemsinfifo ^ itemsinfifo ^ expected_itemsinfifo)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h, empty=%b, full=%b, itemsinfifo=%h",
                         dataout, empty, full, itemsinfifo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h, empty=%b, full=%b, itemsinfifo=%h",
                         expected_dataout, expected_empty, expected_full, expected_itemsinfifo);
                $display("  Got:      dataout=%h, empty=%b, full=%b, itemsinfifo=%h",
                         dataout, empty, full, itemsinfifo);
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
        $dumpvars(0,clk, datain, loaden, rstn, unloaden, dataout, empty, full, itemsinfifo);
    end

endmodule
