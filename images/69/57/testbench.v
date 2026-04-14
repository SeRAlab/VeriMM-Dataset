`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] input_axis_tdata;
    reg [7:0] input_axis_tkeep;
    reg input_axis_tlast;
    reg input_axis_tuser;
    reg input_axis_tvalid;
    reg output_axis_tready;
    reg rst;
    wire input_axis_tready;
    wire [63:0] output_axis_tdata;
    wire [7:0] output_axis_tkeep;
    wire output_axis_tlast;
    wire output_axis_tuser;
    wire output_axis_tvalid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_axis_tdata(input_axis_tdata),
        .input_axis_tkeep(input_axis_tkeep),
        .input_axis_tlast(input_axis_tlast),
        .input_axis_tuser(input_axis_tuser),
        .input_axis_tvalid(input_axis_tvalid),
        .output_axis_tready(output_axis_tready),
        .rst(rst),
        .input_axis_tready(input_axis_tready),
        .output_axis_tdata(output_axis_tdata),
        .output_axis_tkeep(output_axis_tkeep),
        .output_axis_tlast(output_axis_tlast),
        .output_axis_tuser(output_axis_tuser),
        .output_axis_tvalid(output_axis_tvalid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input_axis_tdata = 64'h0;
            input_axis_tkeep = 8'h0;
            input_axis_tlast = 0;
            input_axis_tuser = 0;
            input_axis_tvalid = 0;
            output_axis_tready = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(0, 64'h0, 8'h0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            output_axis_tready = 1;
            input_axis_tdata = 64'hABCDEF0123456789;
            input_axis_tkeep = 8'hFF;
            input_axis_tvalid = 1;
            input_axis_tlast = 0;
            input_axis_tuser = 0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1, 64'hABCDEF0123456789, 8'hFF, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            output_axis_tready = 1;
            input_axis_tdata = 64'h1122334455667788;
            input_axis_tkeep = 8'hAA;
            input_axis_tlast = 1;
            input_axis_tuser = 1;
            input_axis_tvalid = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 64'h1122334455667788, 8'hAA, 1, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            output_axis_tready = 0;
            input_axis_tdata = 64'h5555AAAA5555AAAA;
            input_axis_tvalid = 1;

            @(posedge clk);
            #2;



            #1;




            check_outputs(0, 64'h0, 8'h0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            output_axis_tready = 1;


            input_axis_tdata = 64'hCAFEBABECAFEBABE;
            input_axis_tvalid = 1;
            @(posedge clk);
            #2;


            input_axis_tvalid = 0;
            input_axis_tdata = 64'hDEADBEEFDEADBEEF;
            @(posedge clk);
            #2;




            #1;





            check_outputs(1, 64'hCAFEBABECAFEBABE, 8'h0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            output_axis_tready = 1;


            input_axis_tdata = 64'h1;
            input_axis_tvalid = 1;
            @(posedge clk);
            #2;


            input_axis_tdata = 64'h2;
            input_axis_tvalid = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1, 64'h2, 8'h0, 0, 0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_input_axis_tready;
        input [63:0] expected_output_axis_tdata;
        input [7:0] expected_output_axis_tkeep;
        input expected_output_axis_tlast;
        input expected_output_axis_tuser;
        input expected_output_axis_tvalid;
        begin
            if (expected_input_axis_tready === (expected_input_axis_tready ^ input_axis_tready ^ expected_input_axis_tready) &&
                expected_output_axis_tdata === (expected_output_axis_tdata ^ output_axis_tdata ^ expected_output_axis_tdata) &&
                expected_output_axis_tkeep === (expected_output_axis_tkeep ^ output_axis_tkeep ^ expected_output_axis_tkeep) &&
                expected_output_axis_tlast === (expected_output_axis_tlast ^ output_axis_tlast ^ expected_output_axis_tlast) &&
                expected_output_axis_tuser === (expected_output_axis_tuser ^ output_axis_tuser ^ expected_output_axis_tuser) &&
                expected_output_axis_tvalid === (expected_output_axis_tvalid ^ output_axis_tvalid ^ expected_output_axis_tvalid)) begin
                $display("PASS");
                $display("  Outputs: input_axis_tready=%b, output_axis_tdata=%h, output_axis_tkeep=%h, output_axis_tlast=%b, output_axis_tuser=%b, output_axis_tvalid=%b",
                         input_axis_tready, output_axis_tdata, output_axis_tkeep, output_axis_tlast, output_axis_tuser, output_axis_tvalid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: input_axis_tready=%b, output_axis_tdata=%h, output_axis_tkeep=%h, output_axis_tlast=%b, output_axis_tuser=%b, output_axis_tvalid=%b",
                         expected_input_axis_tready, expected_output_axis_tdata, expected_output_axis_tkeep, expected_output_axis_tlast, expected_output_axis_tuser, expected_output_axis_tvalid);
                $display("  Got:      input_axis_tready=%b, output_axis_tdata=%h, output_axis_tkeep=%h, output_axis_tlast=%b, output_axis_tuser=%b, output_axis_tvalid=%b",
                         input_axis_tready, output_axis_tdata, output_axis_tkeep, output_axis_tlast, output_axis_tuser, output_axis_tvalid);
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
        $dumpvars(0,clk, input_axis_tdata, input_axis_tkeep, input_axis_tlast, input_axis_tuser, input_axis_tvalid, output_axis_tready, rst, input_axis_tready, output_axis_tdata, output_axis_tkeep, output_axis_tlast, output_axis_tuser, output_axis_tvalid);
    end

endmodule
