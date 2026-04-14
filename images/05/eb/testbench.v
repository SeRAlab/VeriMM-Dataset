`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg [2:0] chan_sel;
    reg clk;
    reg rst;
    reg start;
    wire [7:0] data_out;
    wire done;
    wire read;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .addr(addr),
        .chan_sel(chan_sel),
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_out(data_out),
        .done(done),
        .read(read)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            addr = 0;
            chan_sel = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Channel 0 Transfer", test_num);
            reset_dut();

            addr = 8'hA5;
            chan_sel = 3'b000;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done == 1);
            @(posedge clk);



            #1;




            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Channel 7 Transfer", test_num);
            reset_dut();

            addr = 8'h5A;
            chan_sel = 3'b111;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(8'h5A, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Byte Transfer (0xFF)", test_num);
            reset_dut();

            addr = 8'hFF;
            chan_sel = 3'b011;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(8'hFF, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Operation Check", test_num);


            reset_dut();
            addr = 8'h11;
            chan_sel = 3'b001;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);


            reset_dut();
            addr = 8'h22;
            chan_sel = 3'b010;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(8'h22, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input [7:0] expected_data_out;
        input expected_done;
        input expected_read;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_read === (expected_read ^ read ^ expected_read)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b, read=%b",
                         data_out, done, read);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b, read=%b",
                         expected_data_out, expected_done, expected_read);
                $display("  Got:      data_out=%h, done=%b, read=%b",
                         data_out, done, read);
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
        $dumpvars(0,addr, chan_sel, clk, rst, start, data_out, done, read);
    end

endmodule
