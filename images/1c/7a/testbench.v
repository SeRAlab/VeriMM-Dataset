`timescale 1ns/1ps

module stack_lifo_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop_en;
    reg push_en;
    reg rst;
    wire [7:0] data_out;
    wire empty;
    wire full;
    wire [7:0] top_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stack_lifo dut (
        .clk(clk),
        .data_in(data_in),
        .pop_en(pop_en),
        .push_en(push_en),
        .rst(rst),
        .data_out(data_out),
        .empty(empty),
        .full(full),
        .top_data(top_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            push_en = 0;
            pop_en = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Push", test_num);
            reset_dut();
            @(posedge clk);
            push_en = 1;
            data_in = 8'hA5;
            @(posedge clk);
            #1 push_en = 0;

            #1;


            check_outputs(8'h00, 1'b0, 1'b0, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: LIFO Order Check", test_num);
            reset_dut();

            push_en = 1; data_in = 8'h11; @(posedge clk);

            push_en = 1; data_in = 8'h22; @(posedge clk);

            push_en = 1; data_in = 8'h33; @(posedge clk);
            #1 push_en = 0;


            pop_en = 1; @(posedge clk);
            #1 pop_en = 0;


            #1;



            check_outputs(8'h33, 1'b0, 1'b0, 8'h22);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Fill to Full", test_num);
            reset_dut();
            push_en = 1;
            for (i = 1; i <= 8; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end
            #1 push_en = 0;

            #1;


            check_outputs(8'h00, 1'b0, 1'b1, 8'h08);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Full to Empty Transition", test_num);
            reset_dut();

            push_en = 1;
            for (i = 1; i <= 8; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end
            #1 push_en = 0;


            pop_en = 1;
            for (i = 1; i <= 8; i = i + 1) begin
                @(posedge clk);
            end
            #1 pop_en = 0;


            #1;



            check_outputs(8'h01, 1'b1, 1'b0, 8'h00);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: Overflow Check", test_num);
            reset_dut();
            push_en = 1;

            for (i = 1; i <= 9; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end
            #1 push_en = 0;

            #1;


            check_outputs(8'h00, 1'b0, 1'b1, 8'h08);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stack_lifo Testbench");
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
        input [7:0] expected_data_out;
        input expected_empty;
        input expected_full;
        input [7:0] expected_top_data;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_top_data === (expected_top_data ^ top_data ^ expected_top_data)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b, top_data=%h",
                         data_out, empty, full, top_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b, top_data=%h",
                         expected_data_out, expected_empty, expected_full, expected_top_data);
                $display("  Got:      data_out=%h, empty=%b, full=%b, top_data=%h",
                         data_out, empty, full, top_data);
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
        $dumpvars(0,clk, data_in, pop_en, push_en, rst, data_out, empty, full, top_data);
    end

endmodule
