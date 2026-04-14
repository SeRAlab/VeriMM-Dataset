`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [255:0] avm_readdata;
    reg avm_readdatavalid;
    reg avm_waitrequest;
    reg avm_writeack;
    reg clock;
    reg enable;
    reg [31:0] i_globalid0;
    reg [31:0] i_increment;
    reg i_predicate;
    reg i_stall;
    reg i_valid;
    reg resetn;
    wire [31:0] avm_address;
    wire [5:0] avm_burstcount;
    wire [31:0] avm_byteenable;
    wire avm_read;
    wire avm_write;
    wire [255:0] avm_writedata;
    wire [31:0] o_result;
    wire o_stall;
    wire o_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .avm_readdata(avm_readdata),
        .avm_readdatavalid(avm_readdatavalid),
        .avm_waitrequest(avm_waitrequest),
        .avm_writeack(avm_writeack),
        .clock(clock),
        .enable(enable),
        .i_globalid0(i_globalid0),
        .i_increment(i_increment),
        .i_predicate(i_predicate),
        .i_stall(i_stall),
        .i_valid(i_valid),
        .resetn(resetn),
        .avm_address(avm_address),
        .avm_burstcount(avm_burstcount),
        .avm_byteenable(avm_byteenable),
        .avm_read(avm_read),
        .avm_write(avm_write),
        .avm_writedata(avm_writedata),
        .o_result(o_result),
        .o_stall(o_stall),
        .o_valid(o_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            resetn = 0;
            enable = 0;
            i_valid = 0;
            i_predicate = 0;
            i_globalid0 = 0;
            i_increment = 0;
            i_stall = 0;
            avm_readdata = 0;
            avm_readdatavalid = 0;
            avm_waitrequest = 0;
            avm_writeack = 0;
            #20;
            resetn = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Basic Read Operation", test_num);
            reset_dut();


            enable = 1;
            i_valid = 1;
            i_predicate = 1;
            i_globalid0 = 32'h0000_1000;
            i_increment = 32'h0000_0004;


            wait(avm_read === 1);
            @(posedge clock);
            #1;


            avm_readdata = 256'hDEADBEEF_CAFEBABE_00000000_11112222_33334444_55556666_77778888_9999AAAA;
            avm_readdatavalid = 1;
            @(posedge clock);
            #1;
            avm_readdatavalid = 0;



            #1;




            check_outputs(
                32'h0000_1004,
                6'h01,
                32'hFFFFFFFF,
                1'b0,
                1'b0,
                256'h0,
                32'h9999AAAA,
                1'b0,
                1'b1
            );
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Predicated Read (Bypass)", test_num);
            reset_dut();

            enable = 1;
            i_valid = 1;
            i_predicate = 0;
            i_globalid0 = 32'hAABB_CCDD;



            repeat(5) @(posedge clock);

            #1;


            check_outputs(
                avm_address,
                6'h00,
                avm_byteenable,
                1'b0,
                1'b0,
                255'h0,
                32'h0,
                1'b0,
                1'b1
            );
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Memory Wait Request", test_num);
            reset_dut();

            enable = 1;
            i_valid = 1;
            i_predicate = 1;
            avm_waitrequest = 1;

            @(posedge clock);
            #1;


            if (avm_read === 1 && o_stall === 1) begin
                $display("Module correctly waiting for memory...");
            end


            #10;
            avm_waitrequest = 0;
            @(posedge clock);
            #1;


            avm_readdata = 256'h12345678_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
            avm_readdatavalid = 1;
            @(posedge clock);
            #1;
            avm_readdatavalid = 0;

            #1;


            check_outputs(
                avm_address,
                6'h01,
                32'hFFFFFFFF,
                1'b0,
                1'b0,
                256'h0,
                32'h0,
                1'b0,
                1'b1
            );
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Downstream Stall", test_num);
            reset_dut();

            enable = 1;
            i_valid = 1;
            i_predicate = 1;
            i_stall = 1;


            wait(avm_read === 1);
            @(posedge clock);
            #1;
            avm_readdata = 256'h5555AAAA_5555AAAA_5555AAAA_5555AAAA_5555AAAA_5555AAAA_5555AAAA_5555AAAA;
            avm_readdatavalid = 1;
            @(posedge clock);
            #1;
            avm_readdatavalid = 0;


            repeat(3) @(posedge clock);


            i_stall = 0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(
                avm_address,
                6'h01,
                32'hFFFFFFFF,
                1'b0,
                1'b0,
                256'h0,
                32'h5555AAAA,
                o_stall,
                1'b1
            );
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Address Increment", test_num);
            reset_dut();

            enable = 1;
            i_valid = 1;
            i_predicate = 1;
            i_globalid0 = 32'h0000_F000;
            i_increment = 32'h0000_0010;

            wait(avm_read === 1);
            #1;

            #1;


            check_outputs(
                32'h0000_F010,
                6'h01,
                32'hFFFFFFFF,
                1'b1,
                1'b0,
                256'h0,
                o_result,
                o_stall,
                o_valid
            );
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
        input [31:0] expected_avm_address;
        input [5:0] expected_avm_burstcount;
        input [31:0] expected_avm_byteenable;
        input expected_avm_read;
        input expected_avm_write;
        input [255:0] expected_avm_writedata;
        input [31:0] expected_o_result;
        input expected_o_stall;
        input expected_o_valid;
        begin
            if (expected_avm_address === (expected_avm_address ^ avm_address ^ expected_avm_address) &&
                expected_avm_burstcount === (expected_avm_burstcount ^ avm_burstcount ^ expected_avm_burstcount) &&
                expected_avm_byteenable === (expected_avm_byteenable ^ avm_byteenable ^ expected_avm_byteenable) &&
                expected_avm_read === (expected_avm_read ^ avm_read ^ expected_avm_read) &&
                expected_avm_write === (expected_avm_write ^ avm_write ^ expected_avm_write) &&
                expected_avm_writedata === (expected_avm_writedata ^ avm_writedata ^ expected_avm_writedata) &&
                expected_o_result === (expected_o_result ^ o_result ^ expected_o_result) &&
                expected_o_stall === (expected_o_stall ^ o_stall ^ expected_o_stall) &&
                expected_o_valid === (expected_o_valid ^ o_valid ^ expected_o_valid)) begin
                $display("PASS");
                $display("  Outputs: avm_address=%h, avm_burstcount=%h, avm_byteenable=%h, avm_read=%b, avm_write=%b, avm_writedata=%h, o_result=%h, o_stall=%b, o_valid=%b",
                         avm_address, avm_burstcount, avm_byteenable, avm_read, avm_write, avm_writedata, o_result, o_stall, o_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avm_address=%h, avm_burstcount=%h, avm_byteenable=%h, avm_read=%b, avm_write=%b, avm_writedata=%h, o_result=%h, o_stall=%b, o_valid=%b",
                         expected_avm_address, expected_avm_burstcount, expected_avm_byteenable, expected_avm_read, expected_avm_write, expected_avm_writedata, expected_o_result, expected_o_stall, expected_o_valid);
                $display("  Got:      avm_address=%h, avm_burstcount=%h, avm_byteenable=%h, avm_read=%b, avm_write=%b, avm_writedata=%h, o_result=%h, o_stall=%b, o_valid=%b",
                         avm_address, avm_burstcount, avm_byteenable, avm_read, avm_write, avm_writedata, o_result, o_stall, o_valid);
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
        $dumpvars(0,avm_readdata, avm_readdatavalid, avm_waitrequest, avm_writeack, clock, enable, i_globalid0, i_increment, i_predicate, i_stall, i_valid, resetn, avm_address, avm_burstcount, avm_byteenable, avm_read, avm_write, avm_writedata, o_result, o_stall, o_valid);
    end

endmodule
