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
            rstn = 1'b0;
            winc = 1'b0;
            rinc = 1'b0;
            wdata = 8'h00;
            @(posedge clk);
            #1 rstn = 1'b1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset State Check");
            reset_dut();

            #1;


            check_outputs(8'hxx, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Single Write and Single Read");
            reset_dut();


            winc = 1'b1;
            wdata = 8'hA5;
            @(posedge clk);
            winc = 1'b0;
            @(posedge clk);


            rinc = 1'b1;
            @(posedge clk);
            rinc = 1'b0;
            #1;


            #1;



            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nRunning testcase003: Fill FIFO to Full");
            reset_dut();

            winc = 1'b1;
            for (i = 0; i < 16; i = i + 1) begin
                wdata = i[7:0];
                @(posedge clk);
            end
            winc = 1'b0;
            #1;



            #1;




            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("\nRunning testcase004: Read back from Full to Empty");
            reset_dut();


            winc = 1'b1;
            for (i = 0; i < 16; i = i + 1) begin
                wdata = i[7:0];
                @(posedge clk);
            end
            winc = 1'b0;


            rinc = 1'b1;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
            end
            rinc = 1'b0;
            #1;


            #1;



            check_outputs(8'h0F, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("\nRunning testcase005: Overflow Protection");
            reset_dut();


            winc = 1'b1;
            for (i = 0; i < 16; i = i + 1) begin
                wdata = i[7:0];
                @(posedge clk);
            end


            wdata = 8'hFF;
            @(posedge clk);
            @(posedge clk);
            winc = 1'b0;
            #1;


            #1;



            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Underflow Protection");
            reset_dut();


            rinc = 1'b1;
            @(posedge clk);
            @(posedge clk);
            rinc = 1'b0;
            #1;


            #1;



            check_outputs(8'hxx, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Simultaneous Write and Read");
            reset_dut();


            winc = 1'b1;
            wdata = 8'h55;
            @(posedge clk);


            winc = 1'b1;
            rinc = 1'b1;
            wdata = 8'hAA;
            @(posedge clk);
            winc = 1'b0;
            rinc = 1'b0;
            #1;



            #1;




            check_outputs(8'hAA, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        integer i;
        begin
            $display("\nRunning testcase008: Pointer Wraparound Check");
            reset_dut();


            winc = 1'b1;
            for (i = 0; i < 10; i = i + 1) begin
                wdata = i[7:0];
                @(posedge clk);
            end
            winc = 1'b0;


            rinc = 1'b1;
            for (i = 0; i < 10; i = i + 1) @(posedge clk);
            rinc = 1'b0;


            winc = 1'b1;
            for (i = 0; i < 10; i = i + 1) begin
                wdata = 8'hCC;
                @(posedge clk);
            end
            winc = 1'b0;
            #1;


            #1;



            check_outputs(8'hCC, 1'b0, 1'b0);
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
