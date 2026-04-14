`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    reg read_en;
    reg write_en;
    wire [3:0] stored_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .data(data),
        .read_en(read_en),
        .write_en(write_en),
        .stored_data(stored_data)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Write and Read (4'h5)", test_num);

        data = 4'h0; read_en = 0; write_en = 0; #10;


        data = 4'h5; write_en = 1; #10;
        write_en = 0; #10;


        read_en = 1; #10;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Write and Read (4'hA)", test_num);

        data = 4'h0; read_en = 0; write_en = 0; #10;


        data = 4'hA; write_en = 1; #10;
        write_en = 0; #10;


        read_en = 1; #10;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Data Persistence (Write inhibited)", test_num);

        data = 4'h0; read_en = 0; write_en = 0; #10;


        data = 4'h3; write_en = 1; #10;
        write_en = 0;


        data = 4'hF; #10;


        read_en = 1; #10;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Priority Test (Read prioritized over Write)", test_num);

        data = 4'h0; read_en = 0; write_en = 0; #10;


        data = 4'hC; write_en = 1; #10;
        write_en = 0; #10;



        data = 4'h7; read_en = 1; write_en = 1; #10;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verify Write was ignored during Priority Test", test_num);

        data = 4'h0; read_en = 0; write_en = 0; #10;



        data = 4'hC; write_en = 1; #10;
        write_en = 0; #10;


        data = 4'h0; read_en = 1; write_en = 1; #10;


        write_en = 0; read_en = 0; #10;


        read_en = 1; #10;
        #1;

        check_outputs(4'hC);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [3:0] expected_stored_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_stored_data === (expected_stored_data ^ stored_data ^ expected_stored_data)) begin
                $display("PASS");
                $display("  Outputs: stored_data=%h",
                         stored_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stored_data=%h",
                         expected_stored_data);
                $display("  Got:      stored_data=%h",
                         stored_data);
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
