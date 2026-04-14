`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] alu_out;
    reg alu_ready;
    reg [31:0] mem_out;
    reg mem_read;
    reg [4:0] rd_alu;
    reg [4:0] rd_mem;
    reg [4:0] rs1;
    reg [4:0] rs2;
    wire [31:0] forwarded_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .alu_out(alu_out),
        .alu_ready(alu_ready),
        .mem_out(mem_out),
        .mem_read(mem_read),
        .rd_alu(rd_alu),
        .rd_mem(rd_mem),
        .rs1(rs1),
        .rs2(rs2),
        .forwarded_data(forwarded_data)
    );
    task testcase001;

        begin
            $display("Testcase 001: No forwarding needed (different registers)");
            test_num = test_num + 1;
            alu_out = 32'hAAAA_BBBB;
            alu_ready = 1;
            mem_out = 32'hCCCC_DDDD;
            mem_read = 1;
            rd_alu = 5'd10;
            rd_mem = 5'd11;
            rs1 = 5'd1;
            rs2 = 5'd2;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: ALU forward to RS1");
            test_num = test_num + 1;
            alu_out = 32'h1234_5678;
            alu_ready = 1;
            mem_out = 32'h0;
            mem_read = 0;
            rd_alu = 5'd5;
            rd_mem = 5'd0;
            rs1 = 5'd5;
            rs2 = 5'd6;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: ALU forward to RS2");
            test_num = test_num + 1;
            alu_out = 32'h8765_4321;
            alu_ready = 1;
            mem_out = 32'h0;
            mem_read = 0;
            rd_alu = 5'd6;
            rd_mem = 5'd0;
            rs1 = 5'd5;
            rs2 = 5'd6;
            #1;

            check_outputs(32'h8765_4321);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: MEM forward to RS1");
            test_num = test_num + 1;
            alu_out = 32'h0;
            alu_ready = 0;
            mem_out = 32'hFEED_FACE;
            mem_read = 1;
            rd_alu = 5'd0;
            rd_mem = 5'd15;
            rs1 = 5'd15;
            rs2 = 5'd16;
            #1;

            check_outputs(32'hFEED_FACE);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: MEM forward to RS2");
            test_num = test_num + 1;
            alu_out = 32'h0;
            alu_ready = 0;
            mem_out = 32'hDEAD_BEEF;
            mem_read = 1;
            rd_alu = 5'd0;
            rd_mem = 5'd20;
            rs1 = 5'd19;
            rs2 = 5'd20;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: ALU priority over MEM (Hazard on same register)");
            test_num = test_num + 1;
            alu_out = 32'hALU_DATA;
            alu_ready = 1;
            mem_out = 32'hMEM_DATA;
            mem_read = 1;
            rd_alu = 5'd10;
            rd_mem = 5'd10;
            rs1 = 5'd10;
            rs2 = 5'd0;

            #1;


            check_outputs(32'hALU_DATA);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Register 0 hazard (Should NOT forward)");
            test_num = test_num + 1;
            alu_out = 32'hFFFF_FFFF;
            alu_ready = 1;
            mem_out = 32'hEEEE_EEEE;
            mem_read = 1;
            rd_alu = 5'd0;
            rd_mem = 5'd0;
            rs1 = 5'd0;
            rs2 = 5'd0;

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Register match but Ready/Read signal low");
            test_num = test_num + 1;
            alu_out = 32'h1111_2222;
            alu_ready = 0;
            mem_out = 32'h3333_4444;
            mem_read = 0;
            rd_alu = 5'd4;
            rd_mem = 5'd4;
            rs1 = 5'd4;
            rs2 = 5'd4;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding_unit Testbench");
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
        input [31:0] expected_forwarded_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwarded_data === (expected_forwarded_data ^ forwarded_data ^ expected_forwarded_data)) begin
                $display("PASS");
                $display("  Outputs: forwarded_data=%h",
                         forwarded_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwarded_data=%h",
                         expected_forwarded_data);
                $display("  Got:      forwarded_data=%h",
                         forwarded_data);
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

endmodule
