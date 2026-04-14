`timescale 1ns/1ps

module chacha20_state_update_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] counter;
    reg [63:0] key;
    reg [31:0] nonce;
    wire [63:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_state_update dut (
        .counter(counter),
        .key(key),
        .nonce(nonce),
        .state(state)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros Initial State", test_num);
        key = 64'h0;
        counter = 32'h0;
        nonce = 32'h0;
        #1;

        check_outputs(64'h00000000_00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones State", test_num);
        key = 64'hFFFFFFFF_FFFFFFFF;
        counter = 32'hFFFFFFFF;
        nonce = 32'hFFFFFFFF;
        #1;

        check_outputs(64'h00000000_00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Key Sensitivity (Upper 32 bits)", test_num);
        key = 64'hFFFFFFFF_00000000;
        counter = 32'h0;
        nonce = 32'h0;
        #1;

        check_outputs(64'hFFFFFFFF_00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Key Sensitivity (Lower 32 bits)", test_num);
        key = 64'h00000000_FFFFFFFF;
        counter = 32'h0;
        nonce = 32'h0;
        #1;

        check_outputs(64'h00000000_FFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Counter Sensitivity", test_num);
        key = 64'h0;
        counter = 32'hAAAAAAAA;
        nonce = 32'h0;
        #1;

        check_outputs(64'hAAAAAAAA_00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Nonce Sensitivity", test_num);
        key = 64'h0;
        counter = 32'h0;
        nonce = 32'h55555555;
        #1;

        check_outputs(64'h00000000_55555555);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mixed Input Pattern 1", test_num);
        key = 64'h12345678_9ABCDEF0;
        counter = 32'hEDCBA987;
        nonce = 32'h6543210F;

        #1;


        check_outputs(64'hFFFBFFFF_FFFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Bit Change Verification", test_num);
        key = 64'h0;
        counter = 32'h00000001;
        nonce = 32'h0;
        #1;

        check_outputs(64'h00000001_00000000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bit Pattern", test_num);
        key = 64'h55555555_AAAAAAAA;
        counter = 32'h55555555;
        nonce = 32'hAAAAAAAA;
        #1;

        check_outputs(64'h00000000_00000000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large Counter Value", test_num);
        key = 64'hFEDCBA98_76543210;
        counter = 32'hFFFFFFFF;
        nonce = 32'h12345678;

        #1;


        check_outputs(64'h01234567_64606468);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_state_update Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [63:0] expected_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
