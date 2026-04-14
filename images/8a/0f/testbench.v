`timescale 1ns/1ps

module stack_16x32_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pop;
    reg push;
    reg [31:0] push_data;
    reg reset;
    wire empty;
    wire full;
    wire [31:0] pop_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stack_16x32 dut (
        .clk(clk),
        .pop(pop),
        .push(push),
        .push_data(push_data),
        .reset(reset),
        .empty(empty),
        .full(full),
        .pop_data(pop_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            push = 0;
            pop = 0;
            push_data = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset State");
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, 32'hxxxxxxxx);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Push");
            reset_dut();
            push = 1;
            push_data = 32'hAAAA_BBBB;
            @(posedge clk);
            #1;
            push = 0;

            #1;


            check_outputs(1'b0, 1'b0, 32'hAAAA_BBBB);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Fill to Full");
            reset_dut();
            for (i = 0; i < 16; i = i + 1) begin
                push = 1;
                push_data = i;
                @(posedge clk);
                #1;
            end
            push = 0;

            #1;


            check_outputs(1'b0, 1'b1, 32'd15);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: LIFO Data Integrity");
            reset_dut();

            push = 1; push_data = 32'h1; @(posedge clk); #1;
            push = 1; push_data = 32'h2; @(posedge clk); #1;
            push = 0;

            pop = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b0, 1'b0, 32'h1);
            pop = 0;
            #1;
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overflow (Pushing to full stack)");
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                push = 1; push_data = i; @(posedge clk); #1;
            end

            push = 1; push_data = 32'hFFFF_FFFF; @(posedge clk); #1;
            push = 0;

            #1;


            check_outputs(1'b0, 1'b1, 32'd15);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Underflow (Popping from empty stack)");
            reset_dut();
            pop = 1;
            @(posedge clk);
            #1;
            pop = 0;

            #1;


            check_outputs(1'b1, 1'b0, 32'hxxxxxxxx);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Interleaved Push and Pop");
            reset_dut();

            for (i = 0; i < 10; i = i + 1) begin
                push = 1; push_data = i; @(posedge clk); #1;
            end
            push = 0;
            for (i = 0; i < 5; i = i + 1) begin
                pop = 1; @(posedge clk); #1;
            end
            pop = 0;
            push = 1; push_data = 32'hC0DE; @(posedge clk); #1;
            push = 0;

            #1;


            check_outputs(1'b0, 1'b0, 32'hC0DE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stack_16x32 Testbench");
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
        input expected_empty;
        input expected_full;
        input [31:0] expected_pop_data;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_pop_data === (expected_pop_data ^ pop_data ^ expected_pop_data)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, pop_data=%h",
                         empty, full, pop_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, pop_data=%h",
                         expected_empty, expected_full, expected_pop_data);
                $display("  Got:      empty=%b, full=%b, pop_data=%h",
                         empty, full, pop_data);
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
        $dumpvars(0,clk, pop, push, push_data, reset, empty, full, pop_data);
    end

endmodule
