`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] req;
    reg reset;
    wire [7:0] data_out;
    wire [7:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req(req),
        .reset(reset),
        .data_out(data_out),
        .grant(grant)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            req = 8'h00;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Channel Request (CH0)", test_num);
            reset_dut();
            req = 8'b0000_0001;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h01, 8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Single Channel Request (CH7)", test_num);
            reset_dut();
            req = 8'b1000_0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h80, 8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Round-Robin Basic (CH0 then CH1)", test_num);
            reset_dut();
            req = 8'b0000_0011;


            @(posedge clk);
            #1;


            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h02, 8'h02);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Round-Robin Wrap-around (CH7 then CH0)", test_num);
            reset_dut();


            req = 8'b1000_0000;
            @(posedge clk);
            #1;


            req = 8'b1000_0001;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h01, 8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Request Removal (Idle)", test_num);
            reset_dut();

            req = 8'hFF;
            @(posedge clk);
            #1;

            req = 8'h00;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Non-sequential Round-Robin (CH1 then CH4)", test_num);
            reset_dut();
            req = 8'b0001_0010;

            @(posedge clk);
            #1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h10, 8'h10);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = 8;
            $display("Testcase %03d: Full Rotation (All 8 channels)", test_num);
            reset_dut();
            req = 8'hFF;


            for(i=0; i<8; i=i+1) begin
                @(posedge clk);
                #1;
            end

            #1;

            #1;


            check_outputs(8'h80, 8'h80);
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
        input [7:0] expected_grant;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, grant=%h",
                         data_out, grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, grant=%h",
                         expected_data_out, expected_grant);
                $display("  Got:      data_out=%h, grant=%h",
                         data_out, grant);
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
        $dumpvars(0,clk, req, reset, data_out, grant);
    end

endmodule
