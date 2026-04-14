`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg reset;
    reg wr_en;
    wire [7:0] dout;
    wire empty;
    wire full;
    wire rd_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .din(din),
        .reset(reset),
        .wr_en(wr_en),
        .dout(dout),
        .empty(empty),
        .full(full),
        .rd_en(rd_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            din = 0;
            wr_en = 0;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Writing a single sample", test_num);
            reset_dut();


            @(posedge clk);
            din = 8'hA5;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'hA5, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Writing multiple samples (0x11, 0x22)", test_num);
            reset_dut();


            @(posedge clk);
            din = 8'h11;
            wr_en = 1;
            @(posedge clk);


            din = 8'h22;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            repeat(5) @(posedge clk);




            #1;





            check_outputs(8'h11, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Filling the FIFO buffer", test_num);
            reset_dut();


            wr_en = 1;
            for (i = 0; i < 32; i = i + 1) begin
                din = i[7:0];
                @(posedge clk);
            end
            wr_en = 0;


            @(posedge clk);



            #1;




            check_outputs(8'h00, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Emptying the buffer", test_num);
            reset_dut();


            din = 8'hFF;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;



            repeat(20) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b1, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sample_rate_converter Testbench");
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
        input expected_empty;
        input expected_full;
        input expected_rd_en;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_rd_en === (expected_rd_en ^ rd_en ^ expected_rd_en)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b, rd_en=%b",
                         dout, empty, full, rd_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b, rd_en=%b",
                         expected_dout, expected_empty, expected_full, expected_rd_en);
                $display("  Got:      dout=%h, empty=%b, full=%b, rd_en=%b",
                         dout, empty, full, rd_en);
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
        $dumpvars(0,clk, din, reset, wr_en, dout, empty, full, rd_en);
    end

endmodule
