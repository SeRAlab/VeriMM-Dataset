`timescale 1ns/1ps

module wifi_fifo_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg read_en;
    reg reset;
    reg write_en;
    wire [7:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_fifo dut (
        .clk(clk),
        .data_in(data_in),
        .read_en(read_en),
        .reset(reset),
        .write_en(write_en),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h0;
            write_en = 0;
            read_en = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write Status", test_num);
            reset_dut();

            data_in = 8'hAA;
            write_en = 1;
            @(posedge clk);
            #1 write_en = 0;
            @(posedge clk);


            #1;



            check_outputs(data_out, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Fill FIFO (Depth 4)", test_num);
            reset_dut();

            write_en = 1;
            data_in = 8'h11; @(posedge clk);
            data_in = 8'h22; @(posedge clk);
            data_in = 8'h33; @(posedge clk);
            data_in = 8'h44; @(posedge clk);
            #1 write_en = 0;
            @(posedge clk);


            #1;



            check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Data Integrity (First-In First-Out)", test_num);
            reset_dut();


            write_en = 1;
            data_in = 8'hA5;
            @(posedge clk);
            #1 write_en = 0;
            @(posedge clk);


            read_en = 1;
            @(posedge clk);
            #1 read_en = 0;



            #1;




            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Full Sequence (Fill 4 then Empty 4)", test_num);
            reset_dut();


            write_en = 1;
            data_in = 8'h01; @(posedge clk);
            data_in = 8'h02; @(posedge clk);
            data_in = 8'h03; @(posedge clk);
            data_in = 8'h04; @(posedge clk);
            #1 write_en = 0;


            read_en = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1 read_en = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h04, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Overflow Handling", test_num);
            reset_dut();


            write_en = 1;
            data_in = 8'hD1; @(posedge clk);
            data_in = 8'hD2; @(posedge clk);
            data_in = 8'hD3; @(posedge clk);
            data_in = 8'hD4; @(posedge clk);

            data_in = 8'hFF; @(posedge clk);
            #1 write_en = 0;


            read_en = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1 read_en = 0;
            @(posedge clk);


            #1;



            check_outputs(8'hD4, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Underflow Handling", test_num);
            reset_dut();


            read_en = 1;
            @(posedge clk);
            #1 read_en = 0;
            @(posedge clk);


            #1;



            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            write_en = 1;
            data_in = 8'hB1;
            @(posedge clk);


            data_in = 8'hB2;
            write_en = 1;
            read_en = 1;
            @(posedge clk);
            #1 write_en = 0;
            read_en = 0;
            @(posedge clk);


            #1;



            check_outputs(8'hB1, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_fifo Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b",
                         expected_data_out, expected_empty, expected_full);
                $display("  Got:      data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
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
        $dumpvars(0,clk, data_in, read_en, reset, write_en, data_out, empty, full);
    end

endmodule
