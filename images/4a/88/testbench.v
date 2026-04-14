`timescale 1ns/1ps

module sync_fifo_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rinc;
    reg rstn;
    reg [7:0] wdata;
    reg winc;
    wire [7:0] rdata;
    wire rempty;
    wire wfull;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_fifo dut (
        .clk(clk),
        .rinc(rinc),
        .rstn(rstn),
        .wdata(wdata),
        .winc(winc),
        .rdata(rdata),
        .rempty(rempty),
        .wfull(wfull)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            winc = 0;
            rinc = 0;
            wdata = 0;
            @(posedge clk);
            #1;
            rstn = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Write and Single Read", test_num);
            reset_dut();


            @(negedge clk);
            winc = 1; wdata = 8'hA5;
            @(negedge clk);
            winc = 0;


            @(negedge clk);
            rinc = 1;
            @(negedge clk);
            rinc = 0;

            @(posedge clk); #1;

            #1;


            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill FIFO to Full", test_num);
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                @(negedge clk);
                winc = 1; wdata = i;
            end
            @(negedge clk);
            winc = 0;

            @(posedge clk); #1;

            #1;


            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Empty FIFO from Full", test_num);
            reset_dut();


            for (i = 0; i < 16; i = i + 1) begin
                @(negedge clk);
                winc = 1; wdata = i;
            end
            @(negedge clk);
            winc = 0;


            for (i = 0; i < 16; i = i + 1) begin
                @(negedge clk);
                rinc = 1;
            end
            @(negedge clk);
            rinc = 0;

            @(posedge clk); #1;

            #1;


            check_outputs(8'h0F, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow Test", test_num);
            reset_dut();


            for (i = 0; i < 17; i = i + 1) begin
                @(negedge clk);
                winc = 1; wdata = i;
            end
            @(negedge clk);
            winc = 0;

            @(posedge clk); #1;

            #1;


            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Underflow Test", test_num);
            reset_dut();


            @(negedge clk);
            rinc = 1;
            @(negedge clk);
            rinc = 0;

            @(posedge clk); #1;

            #1;


            check_outputs(rdata, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            @(negedge clk);
            winc = 1; wdata = 8'h55;
            @(negedge clk);
            winc = 0;


            @(negedge clk);
            winc = 1; wdata = 8'hAA;
            rinc = 1;
            @(negedge clk);
            winc = 0; rinc = 0;

            @(posedge clk); #1;


            #1;



            check_outputs(8'h55, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pointer Wrap-around", test_num);
            reset_dut();


            for (i = 0; i < 10; i = i + 1) begin
                @(negedge clk);
                winc = 1; wdata = i;
                @(negedge clk);
                winc = 0;
                @(negedge clk);
                rinc = 1;
                @(negedge clk);
                rinc = 0;
            end


            for (i = 0; i < 10; i = i + 1) begin
                @(negedge clk);
                winc = 1; wdata = 8'hEE;
            end
            @(negedge clk);
            winc = 0;

            @(posedge clk); #1;

            #1;


            check_outputs(8'hEE, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_fifo Testbench");
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
        input [7:0] expected_rdata;
        input expected_rempty;
        input expected_wfull;
        begin
            if (expected_rdata === (expected_rdata ^ rdata ^ expected_rdata) &&
                expected_rempty === (expected_rempty ^ rempty ^ expected_rempty) &&
                expected_wfull === (expected_wfull ^ wfull ^ expected_wfull)) begin
                $display("PASS");
                $display("  Outputs: rdata=%h, rempty=%b, wfull=%b",
                         rdata, rempty, wfull);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata=%h, rempty=%b, wfull=%b",
                         expected_rdata, expected_rempty, expected_wfull);
                $display("  Got:      rdata=%h, rempty=%b, wfull=%b",
                         rdata, rempty, wfull);
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
        $dumpvars(0,clk, rinc, rstn, wdata, winc, rdata, rempty, wfull);
    end

endmodule
