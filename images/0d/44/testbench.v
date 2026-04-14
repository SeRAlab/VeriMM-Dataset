`timescale 1ns/1ps

module uart_tx_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg rst;
    reg tx_en;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_tx dut (
        .clk(clk),
        .data(data),
        .rst(rst),
        .tx_en(tx_en),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            tx_en = 0;
            data = 0;
            #20;
            rst = 0;
            #20;
        end
        endtask
    task testcase001;

        reg [7:0] val;
        reg [8:0] captured;
        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();
            val = 8'h55;
            data = val;

            @(posedge clk);
            tx_en = 1;
            @(posedge clk);
            tx_en = 0;



            for (i = 0; i < 9; i = i + 1) begin
                @(negedge clk);
                captured[i] = tx;
            end



            if (captured === {1'b1, val}) begin
                $display("Testcase %0d: Data 0x%h - All bits matched correctly.", test_num, val);
                #1;

                check_outputs(tx);
            end else begin
                $display("Testcase %0d: Data 0x%h - Mismatch! Expected %b, Got %b", test_num, val, {1'b1, val}, captured);
                #1;

                check_outputs(~tx);
            end
        end
        endtask

    task testcase002;

        reg [7:0] val;
        reg [8:0] captured;
        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();
            val = 8'hAA;
            data = val;

            @(posedge clk);
            tx_en = 1;
            @(posedge clk);
            tx_en = 0;

            for (i = 0; i < 9; i = i + 1) begin
                @(negedge clk);
                captured[i] = tx;
            end

            if (captured === {1'b1, val}) begin
                $display("Testcase %0d: Data 0x%h - All bits matched correctly.", test_num, val);
                #1;

                check_outputs(tx);
            end else begin
                $display("Testcase %0d: Data 0x%h - Mismatch! Expected %b, Got %b", test_num, val, {1'b1, val}, captured);
                #1;

                check_outputs(~tx);
            end
        end
        endtask

    task testcase003;

        reg [7:0] val;
        reg [8:0] captured;
        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();
            val = 8'h00;
            data = val;

            @(posedge clk);
            tx_en = 1;
            @(posedge clk);
            tx_en = 0;

            for (i = 0; i < 9; i = i + 1) begin
                @(negedge clk);
                captured[i] = tx;
            end

            if (captured === {1'b1, val}) begin
                $display("Testcase %0d: Data 0x%h - All bits matched correctly.", test_num, val);
                #1;

                check_outputs(tx);
            end else begin
                $display("Testcase %0d: Data 0x%h - Mismatch! Expected %b, Got %b", test_num, val, {1'b1, val}, captured);
                #1;

                check_outputs(~tx);
            end
        end
        endtask

    task testcase004;

        reg [7:0] val;
        reg [8:0] captured;
        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();
            val = 8'hFF;
            data = val;

            @(posedge clk);
            tx_en = 1;
            @(posedge clk);
            tx_en = 0;

            for (i = 0; i < 9; i = i + 1) begin
                @(negedge clk);
                captured[i] = tx;
            end

            if (captured === {1'b1, val}) begin
                $display("Testcase %0d: Data 0x%h - All bits matched correctly.", test_num, val);
                #1;

                check_outputs(tx);
            end else begin
                $display("Testcase %0d: Data 0x%h - Mismatch! Expected %b, Got %b", test_num, val, {1'b1, val}, captured);
                #1;

                check_outputs(~tx);
            end
        end
        endtask

    task testcase005;

        reg [7:0] val;
        reg [8:0] captured;
        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();
            val = 8'hA5;
            data = val;

            @(posedge clk);
            tx_en = 1;
            @(posedge clk);
            tx_en = 0;

            for (i = 0; i < 9; i = i + 1) begin
                @(negedge clk);
                captured[i] = tx;
            end

            if (captured === {1'b1, val}) begin
                $display("Testcase %0d: Data 0x%h - All bits matched correctly.", test_num, val);
                #1;

                check_outputs(tx);
            end else begin
                $display("Testcase %0d: Data 0x%h - Mismatch! Expected %b, Got %b", test_num, val, {1'b1, val}, captured);
                #1;

                check_outputs(~tx);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("uart_tx Testbench");
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
        input expected_tx;
        begin
            if (expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: tx=%b",
                         tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx=%b",
                         expected_tx);
                $display("  Got:      tx=%b",
                         tx);
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
        $dumpvars(0,clk, data, rst, tx_en, tx);
    end

endmodule
