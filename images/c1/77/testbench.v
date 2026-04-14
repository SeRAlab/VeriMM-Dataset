`timescale 1ns/1ps

module clock_seg7led_interface_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg rd;
    reg [2:0] rd_addr;
    reg rst;
    reg wr;
    reg [2:0] wr_addr;
    wire [7:0] dout;
    wire [7:0] seg7_data;
    wire [7:0] seg7_sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_seg7led_interface dut (
        .clk(clk),
        .din(din),
        .rd(rd),
        .rd_addr(rd_addr),
        .rst(rst),
        .wr(wr),
        .wr_addr(wr_addr),
        .dout(dout),
        .seg7_data(seg7_data),
        .seg7_sel(seg7_sel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            din = 0;
            wr = 0;
            rd = 0;
            wr_addr = 0;
            rd_addr = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Write and Read Buffer 0", test_num);
            reset_dut();


            @(posedge clk);
            wr = 1;
            wr_addr = 3'b000;
            din = 8'hA5;
            @(posedge clk);
            wr = 0;


            @(posedge clk);
            rd = 1;
            rd_addr = 3'b000;
            @(posedge clk);
            #1;



            #1;




            check_outputs(8'hA5, seg7_data, seg7_sel);
            rd = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Write and Read Buffer 3", test_num);
            reset_dut();


            @(posedge clk);
            wr = 1;
            wr_addr = 3'b011;
            din = 8'h5A;
            @(posedge clk);
            wr = 0;


            @(posedge clk);
            rd = 1;
            rd_addr = 3'b011;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h5A, seg7_data, seg7_sel);
            rd = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Multiple Buffer Storage Persistence", test_num);
            reset_dut();


            @(posedge clk);
            wr = 1; wr_addr = 3'b000; din = 8'h11;
            @(posedge clk);

            wr_addr = 3'b001; din = 8'h22;
            @(posedge clk);
            wr = 0;


            @(posedge clk);
            rd = 1; rd_addr = 3'b000;
            @(posedge clk);
            #1;
            if (dout == 8'h11) begin

                rd_addr = 3'b001;
                @(posedge clk);
                #1;
                #1;

                check_outputs(8'h22, seg7_data, seg7_sel);
            end else begin
                #1;

                check_outputs(8'h11, seg7_data, seg7_sel);
            end
            rd = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();


            rd = 1;
            rd_addr = 3'b000;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00, seg7_data, seg7_sel);
            rd = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Sequential Read Operation", test_num);
            reset_dut();


            @(posedge clk);
            wr = 1; wr_addr = 3'b010; din = 8'hCC;
            @(posedge clk);
            wr = 0;


            @(posedge clk);
            rd = 1; rd_addr = 3'b010;
            @(posedge clk);
            #1;


            rd_addr = 3'b000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, seg7_data, seg7_sel);
            rd = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("clock_seg7led_interface Testbench");
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
        input [7:0] expected_dout;
        input [7:0] expected_seg7_data;
        input [7:0] expected_seg7_sel;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_seg7_data === (expected_seg7_data ^ seg7_data ^ expected_seg7_data) &&
                expected_seg7_sel === (expected_seg7_sel ^ seg7_sel ^ expected_seg7_sel)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, seg7_data=%h, seg7_sel=%h",
                         dout, seg7_data, seg7_sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, seg7_data=%h, seg7_sel=%h",
                         expected_dout, expected_seg7_data, expected_seg7_sel);
                $display("  Got:      dout=%h, seg7_data=%h, seg7_sel=%h",
                         dout, seg7_data, seg7_sel);
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
        $dumpvars(0,clk, din, rd, rd_addr, rst, wr, wr_addr, dout, seg7_data, seg7_sel);
    end

endmodule
